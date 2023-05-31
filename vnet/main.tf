resource "azurerm_virtual_network" "vnet_cluster" {
  name                = "AksVnet"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.aks_network["vnet"]]

  tags = var.tags
}

resource "azurerm_subnet" "aks" {
  name                 = "AksSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet_cluster.name
  address_prefixes     = [var.aks_network["workers_subnet"]]
}