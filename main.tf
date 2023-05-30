module "resource_group" {
  source              = "../terraform/spoke/resource-group"
  group_prefix        = replace(join("-", [var.project_name, var.jira_project_id]), "/", "")
  location            = var.location
  resource_group_tags = merge(local.tags, var.resource_group_tags)
}

module "nsg" {
  depends_on = [module.resource_group]
  source     = "../terraform/spoke/nsg"

  name_prefix         = local.resource_prefix
  name_suffix         = local.resource_suffix
  location            = var.location
  resource_group_name = module.resource_group.name
  tags                = local.tags
}

module "vnets" {
  depends_on = [module.resource_group, module.nsg]

  source = "../terraform/spoke/vnet"

  location            = var.location
  resource_group_name = module.resource_group.name
  subnet_nsg_id       = module.nsg.aks_subnet_nsg_id
  aks_network         = local.aks_network
  tags                = local.tags
  aks_idx             = var.aks_idx
}

module "vnet_peerings" {
  depends_on = [
    module.resource_group,
    module.vnets,
  ]
  source = "../terraform/spoke/vnet_peerings"

  location                  = var.location
  spoke_resource_group_name = module.resource_group.name
  hub_resource_group_name   = var.hub_resource_group_name
  tags                      = local.tags
  cluster_vnet              = {
    id   = module.vnets.aks_vnet_id
    name = module.vnets.aks_vnet_name
  }
  hub_vnet = {
    id   = var.hub_vnet_id
    name = var.hub_vnet_name
  }
  aks_idx = var.aks_idx
}

module "route_table" {
  depends_on = [
    module.vnets,
    # if the vnet peering is not there, the route table will not work
    # and will make the aks cluster installation fail
    module.vnet_peerings,
    module.resource_group,
  ]
  source     = "../terraform/spoke/route-table"

  location              = var.location
  resource_group_name   = module.resource_group.name
  tags                  = local.tags
  aks_subnet_id         = module.vnets.aks_snet_id
  fw_private_ip_address = var.fw_private_ip_address
}

module "dns_zones" {
  depends_on = [module.resource_group]
  source     = "../terraform/spoke/dns-zones"

  aks_idx                   = var.aks_idx
  spoke_resource_group_name = module.resource_group.name
  hub_resource_group_name   = var.hub_resource_group_name
  cluster_vnet              = {
    id   = module.vnets.aks_vnet_id
    name = module.vnets.aks_vnet_name
  }
  hub_vnet = {
    id   = var.hub_vnet_id
    name = var.hub_vnet_name
  }
  acr_dns_zone_name  = var.acr_dns_zone_name
  psql_dns_zone_name = var.psql_dns_zone_name
  blob_dns_zone_name = var.blob_dns_zone_name
  tags               = local.tags
}

module "managed_identities" {
  depends_on = [module.dns_zones, module.vnets, module.resource_group]
  source     = "../terraform/spoke/managed-identities"

  location            = var.location
  resource_group_name = module.resource_group.name
  resource_group_id   = module.resource_group.id
  aks_vnet_id         = module.vnets.aks_vnet_id
  dns_zone_id         = module.dns_zones.aks-zone-id

  tags = local.tags
}

module "kubernetes_clusters" {
  depends_on = [
    module.resource_group,
    module.vnets,
    module.dns_zones,
    # if the peerings are not put as a dependency, then terraform destroy will fail,
    # because the vnet peerings might be deleted too early, and connection to the
    # aks vnet will be lost, which can be a problem when deleting the whole spoke infra
    module.vnet_peerings,
    # if the route table is not ready, the cluster installation will fail
    module.route_table,
    module.managed_identities,
  ]
  source = "../terraform/spoke/kubernetes-clusters"

  resource_group_name       = module.resource_group.name
  enable_log_analytics      = var.enable_log_analytics
  name_prefix               = local.resource_prefix
  name_suffix               = local.resource_suffix
  location                  = var.location
  name                      = join("-", [local.aks_name, var.aks_idx])
  dns_prefix                = local.aks_name
  sku_tier                  = var.aks_sku_tier
  user_assigned_identity_id = module.managed_identities.aks_id
  dns_zone_id               = module.dns_zones.aks-zone-id
  workers_subnet_id         = module.vnets.aks_snet_id
  kubernetes_version        = var.kubernetes_version

  cpu_node_pool_vm_size   = var.aks_cpu_node_pool_vm_size
  cpu_node_pool_min_count = var.aks_cpu_node_pool_min_count
  cpu_node_pool_max_count = var.aks_cpu_node_pool_max_count

  add_gpu_node_pool       = var.add_gpu_node_pool
  gpu_node_pool_vm_size   = var.aks_gpu_node_pool_vm_size
  gpu_node_pool_name      = var.aks_gpu_node_pool_name
  gpu_node_pool_min_count = var.aks_gpu_node_pool_min_count
  gpu_node_pool_max_count = var.aks_gpu_node_pool_max_count

  add_aial_node_pool       = var.add_aial_node_pool
  aial_node_pool_vm_size   = var.aks_aial_node_pool_vm_size
  aial_node_pool_name      = var.aks_aial_node_pool_name
  aial_node_pool_min_count = var.aks_aial_node_pool_min_count
  aial_node_pool_max_count = var.aks_aial_node_pool_max_count

  tags = local.tags
}

module "acr_aks_role_assignment" {
  depends_on = [
    module.kubernetes_clusters,
  ]
  source = "../terraform/spoke/roles"

  principal_id = module.kubernetes_clusters.kubernetes_principal_id
  scope        = var.acr_id
}

provider "helm" {
  kubernetes {
    host                   = module.kubernetes_clusters.kubernetes_host
    client_certificate     = module.kubernetes_clusters.kubernetes_client_certificate
    client_key             = module.kubernetes_clusters.kubernetes_client_key
    cluster_ca_certificate = module.kubernetes_clusters.kubernetes_cluster_ca_certificate
  }
}

module "ingress_controller" {
  depends_on = [
    module.vnets,
    module.dns_zones,
    module.kubernetes_clusters,
    module.acr_aks_role_assignment,
    module.resource_group,
  ]
  source = "../terraform/spoke/ingress-controllers"

  chart_version             = var.nginx_ingress_helm_chart_version
  ilb_subnet_name           = module.vnets.aks_ingress_snet_name
  private_link_service_name = "aks-${var.aks_idx}-pls"
  namespace                 = var.ingress_controller_namespace
  node_resource_group_name  = module.kubernetes_clusters.node_resource_group_name
  connection_name           = "connect-to-aks-${var.aks_idx}-pls"
  private_endpoint_name     = "aks-${var.aks_idx}-endpoint"
  resource_group_name       = module.resource_group.name
  subnet_id                 = module.vnets.aks_ingress_snet_id
  aks_dns_zone_name         = module.dns_zones.aks-zone-name
  a_record_name             = "workers"
  ilb_pls_id                = var.ilb_pls_id
  tags                      = local.tags
}