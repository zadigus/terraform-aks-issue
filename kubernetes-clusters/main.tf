resource "azurerm_log_analytics_workspace" "aks" {
  count = var.enable_log_analytics ? 1 : 0

  name                = local.log_analytics_workspace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.log_analytics_workspace_sku
}

resource "azurerm_log_analytics_solution" "aks" {
  count = var.enable_log_analytics ? 1 : 0

  solution_name         = "ContainerInsights"
  location              = var.location
  resource_group_name   = var.resource_group_name
  workspace_resource_id = azurerm_log_analytics_workspace.aks[0].id
  workspace_name        = azurerm_log_analytics_workspace.aks[0].name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}

resource "azurerm_kubernetes_cluster" "cluster" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  private_dns_zone_id = var.dns_zone_id

  # TODO: activate
  # cf. https://learn.microsoft.com/en-us/azure/aks/api-server-vnet-integration
  #  api_server_access_profile {
  #    subnet_id = "TBD"
  #    vnet_integration_enabled = true
  #  }

  # TODO: activate
  # this produces a oidc_issuer_url that is then used for authentication
#  oidc_issuer_enabled       = true
#  workload_identity_enabled = true

  private_cluster_enabled           = true
  role_based_access_control_enabled = true
  kubernetes_version                = var.kubernetes_version
  local_account_disabled            = false
  public_network_access_enabled     = false
  sku_tier                          = var.sku_tier
  # https://learn.microsoft.com/en-ie/azure/governance/policy/concepts/policy-for-kubernetes
  azure_policy_enabled              = true

  auto_scaler_profile {
    balance_similar_node_groups      = false
    empty_bulk_delete_max            = "10"
    expander                         = "random"
    max_graceful_termination_sec     = "600"
    max_node_provisioning_time       = "15m"
    max_unready_nodes                = 3
    max_unready_percentage           = 45
    new_pod_scale_up_delay           = "0s"
    scale_down_delay_after_add       = "10m"
    scale_down_delay_after_delete    = "10s"
    scale_down_delay_after_failure   = "3m"
    scale_down_unneeded              = "10m"
    scale_down_unready               = "20m"
    scale_down_utilization_threshold = "0.5"
    scan_interval                    = "10s"
    skip_nodes_with_local_storage    = false
    skip_nodes_with_system_pods      = true
  }

  default_node_pool {
    name                         = "agentpool"
    vm_size                      = var.cpu_node_pool_vm_size
    max_pods                     = 30
    // we should not define the node_count with auto-scaling enabled
    // because terraform updates won't work because terraform is not
    // allowed to change the node_count to some fixed value other than
    // that set through auto-scaling; e.g. the cluster has been running
    // for some time and has up to 7 nodes while node_count = 3; terraform
    // update will not be able to update the cluster because the process would
    // have to force the node_count to be set to 3 while auto-scaling is enabled,
    // which is a contradiction
    min_count                    = var.cpu_node_pool_min_count
    max_count                    = var.cpu_node_pool_max_count
    enable_auto_scaling          = true
    enable_host_encryption       = false
    enable_node_public_ip        = false
    fips_enabled                 = false
    kubelet_disk_type            = "OS"
    node_labels                  = {}
    node_taints                  = []
    only_critical_addons_enabled = false
    orchestrator_version         = var.kubernetes_version
    os_disk_size_gb              = 256
    os_disk_type                 = "Ephemeral"
    os_sku                       = "Ubuntu"
    tags                         = {}
    type                         = "VirtualMachineScaleSets"
    ultra_ssd_enabled            = false
    vnet_subnet_id               = var.workers_subnet_id
  }

  # TODO: make this configurable (define variable)
  # TODO: is this network_profile OK?
  network_profile {
    load_balancer_sku = "standard"
    # TODO: kubenet only works for small testing use-cases; we need azure cni
    #   https://learn.microsoft.com/en-us/azure/aks/operator-best-practices-network#choose-the-appropriate-network-model
    # TODO: azure cni requires proper planification of IP addresses for pods
    #   https://learn.microsoft.com/en-us/azure/aks/configure-azure-cni
    network_plugin    = "azure"
    dns_service_ip    = "192.168.1.1"
    service_cidr      = "192.168.0.0/16"
    outbound_type     = "userDefinedRouting"
    network_policy    = "azure"
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [var.user_assigned_identity_id]
  }

  dynamic "oms_agent" {
    for_each = var.enable_log_analytics ? ["_"] : []
    content {
      log_analytics_workspace_id = azurerm_log_analytics_workspace.aks[0].id
    }
  }

  tags = var.tags

  timeouts {}
}

resource "azurerm_kubernetes_cluster_node_pool" "gpu" {
  # conditional deployment
  count = var.add_gpu_node_pool ? 1 : 0

  name                   = var.gpu_node_pool_name
  kubernetes_cluster_id  = azurerm_kubernetes_cluster.cluster.id
  vm_size                = var.gpu_node_pool_vm_size
  node_count             = 1
  min_count              = var.gpu_node_pool_min_count
  max_count              = var.gpu_node_pool_max_count
  enable_auto_scaling    = true
  enable_host_encryption = false
  enable_node_public_ip  = false
  fips_enabled           = false
  kubelet_disk_type      = "OS"
  node_labels            = {}
  node_taints            = ["sku=gpu:NoSchedule"]
  os_disk_size_gb        = 128
  os_disk_type           = "Managed"
  os_sku                 = "Ubuntu"
  tags                   = {}
  ultra_ssd_enabled      = false
  vnet_subnet_id         = var.workers_subnet_id
}

resource "azurerm_kubernetes_cluster_node_pool" "aial" {
  # conditional deployment
  count = var.add_aial_node_pool ? 1 : 0

  name                   = var.aial_node_pool_name
  kubernetes_cluster_id  = azurerm_kubernetes_cluster.cluster.id
  vm_size                = var.aial_node_pool_vm_size
  node_count             = 1
  min_count              = var.aial_node_pool_min_count
  max_count              = var.aial_node_pool_max_count
  enable_auto_scaling    = true
  enable_host_encryption = false
  enable_node_public_ip  = false
  fips_enabled           = false
  kubelet_disk_type      = "OS"
  node_labels            = {}
  node_taints            = ["sku=gpu:NoSchedule"]
  os_disk_size_gb        = 128
  os_disk_type           = "Managed"
  os_sku                 = "Ubuntu"
  tags                   = {}
  ultra_ssd_enabled      = false
  vnet_subnet_id         = var.workers_subnet_id
}