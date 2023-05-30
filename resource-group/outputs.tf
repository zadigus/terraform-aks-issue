output "name" {
  description = "The name of resource group created."
  value       = azurerm_resource_group.rg.name
}

output "id" {
  description = "The id of resource group created."
  value       = azurerm_resource_group.rg.id
}
