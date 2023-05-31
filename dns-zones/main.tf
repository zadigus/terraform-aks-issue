resource "azurerm_private_dns_zone" "aks" {
  name                = "aks.privatelink.eastus.azmk8s.io"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}