resource "azurerm_virtual_network" "vnet_cluster" {
  name                = "AksVnet-${var.aks_idx}"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.aks_network["vnet"]]

  tags = var.tags
}

resource "azurerm_subnet" "aks" {
  name                 = "AksSubnet-${var.aks_idx}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet_cluster.name
  address_prefixes     = [var.aks_network["workers_subnet"]]
  # this is necessary to give the aks cluster access to the storage account
  # (only if the storage account is private)
  service_endpoints    = ["Microsoft.Storage"]
}

resource "azurerm_subnet_network_security_group_association" "aks" {
  subnet_id                 = azurerm_subnet.aks.id
  network_security_group_id = var.subnet_nsg_id
}

# this subnet is necessary if we use the azure cni plugin, as exposed by the following unresolved issue:
#  https://github.com/kubernetes/kubernetes/issues/95555
# and as documented in the following list of limitations:
#  https://cloud-provider-azure.sigs.k8s.io/topics/pls-integration/#restrictions
resource "azurerm_subnet" "ingress" {
  name                 = "IngressSubnet-${var.aks_idx}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet_cluster.name
  address_prefixes     = [var.aks_network["ingress_subnet"]]
}

resource "azurerm_subnet_network_security_group_association" "ingress" {
  subnet_id                 = azurerm_subnet.ingress.id
  network_security_group_id = var.subnet_nsg_id
}