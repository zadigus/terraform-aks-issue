output "aks_vnet_id" {
  value = azurerm_virtual_network.vnet_cluster.id
}

output "aks_vnet_name" {
  value = azurerm_virtual_network.vnet_cluster.name
}

output "aks_snet_id" {
  value = azurerm_subnet.aks.id
}