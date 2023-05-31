resource "azurerm_user_assigned_identity" "aks-identity" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = "aks-uai"
  tags                = var.tags
}

resource "azurerm_role_assignment" "aks-dns" {
  scope                = var.dns_zone_id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.aks-identity.principal_id
}

resource "azurerm_role_assignment" "aks-network-contributor" {
  scope                = var.aks_vnet_id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks-identity.principal_id
}