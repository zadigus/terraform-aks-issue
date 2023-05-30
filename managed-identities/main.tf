######################################
#     AKS User-Assigned Identity
######################################
resource "azurerm_user_assigned_identity" "aks-identity" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = "aks-uai"
  tags                = var.tags
}

# this is necessary for the azure cni plugin to create ips for pods in DNS zone
resource "azurerm_role_assignment" "aks-dns" {
  scope                = var.dns_zone_id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.aks-identity.principal_id
}

# TODO: can we restrict this to the VNet?
# this is necessary for the nginx-ingress installation
resource "azurerm_role_assignment" "aks-vm" {
  scope                = var.resource_group_id
  role_definition_name = "Virtual Machine Contributor"
  principal_id         = azurerm_user_assigned_identity.aks-identity.principal_id
}

# this is necessary for the nginx-ingress installation
resource "azurerm_role_assignment" "aks-ds" {
  scope                = var.resource_group_id
  role_definition_name = "Domain Services Contributor"
  principal_id         = azurerm_user_assigned_identity.aks-identity.principal_id
}

// this is required to configure azure-cni
//  https://learn.microsoft.com/en-us/azure/aks/configure-azure-cni#prerequisites
// and to define the internal load-balancer ip in a subnet
//  https://learn.microsoft.com/en-us/azure/aks/internal-lb#use-private-networks
//  https://github.com/hashicorp/terraform-provider-azurerm/issues/2159#issuecomment-433141091
resource "azurerm_role_assignment" "aks-network-contributor" {
  scope                = var.aks_vnet_id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks-identity.principal_id
}