module "resource_group" {
  source              = "./resource-group"
  group_prefix        = replace(join("-", [var.project_name, var.jira_project_id]), "/", "")
  location            = var.location
  resource_group_tags = merge(local.tags, var.resource_group_tags)
}

module "vnets" {
  depends_on = [module.resource_group]

  source = "./vnet"

  location            = var.location
  resource_group_name = module.resource_group.name
  aks_network         = local.aks_network
  tags                = local.tags
}

module "dns_zones" {
  depends_on = [module.resource_group]
  source     = "./dns-zones"

  resource_group_name = module.resource_group.name
  cluster_vnet        = {
    id   = module.vnets.aks_vnet_id
    name = module.vnets.aks_vnet_name
  }
  tags = local.tags
}

module "managed_identities" {
  depends_on = [module.dns_zones, module.vnets, module.resource_group]
  source     = "./managed-identities"

  location            = var.location
  resource_group_name = module.resource_group.name
  aks_vnet_id         = module.vnets.aks_vnet_id
  dns_zone_id         = module.dns_zones.aks-zone-id

  tags = local.tags
}

module "kubernetes_clusters" {
  depends_on = [
    module.resource_group,
    module.vnets,
    module.dns_zones,
    module.managed_identities,
  ]
  source = "./kubernetes-clusters"

  resource_group_name       = module.resource_group.name
  location                  = var.location
  name                      = local.aks_name
  dns_prefix                = local.aks_name
  sku_tier                  = var.aks_sku_tier
  user_assigned_identity_id = module.managed_identities.aks_id
  dns_zone_id               = module.dns_zones.aks-zone-id
  workers_subnet_id         = module.vnets.aks_snet_id
  kubernetes_version        = var.kubernetes_version

  cpu_node_pool_vm_size   = var.aks_cpu_node_pool_vm_size
  cpu_node_pool_min_count = var.aks_cpu_node_pool_min_count
  cpu_node_pool_max_count = var.aks_cpu_node_pool_max_count

  tags = local.tags
}