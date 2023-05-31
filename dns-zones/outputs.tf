output "aks-zone-id" {
  value = azurerm_private_dns_zone.aks.id
}

output "aks-zone-name" {
  value = azurerm_private_dns_zone.aks.name
}