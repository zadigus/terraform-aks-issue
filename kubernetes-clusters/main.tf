resource "azurerm_kubernetes_cluster" "cluster" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  private_dns_zone_id = var.dns_zone_id

  private_cluster_enabled           = true
  role_based_access_control_enabled = true
  kubernetes_version                = var.kubernetes_version
  local_account_disabled            = false
  public_network_access_enabled     = false
  sku_tier                          = var.sku_tier
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

  network_profile {
    load_balancer_sku = "standard"
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

  tags = var.tags

  timeouts {}
}