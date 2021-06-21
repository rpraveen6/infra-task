# Create a virtual network within the resource group
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet-name
  resource_group_name = azurerm_resource_group.k8s.name
  location            = azurerm_resource_group.k8s.location
  address_space       = [var.vnet-address]
  tags = var.tags
}

resource "azurerm_subnet" "akssubnet" {
  name = var.aks-subnet-name
  resource_group_name = azurerm_resource_group.k8s.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [var.aks-subnet-address]

  lifecycle {
    ignore_changes = [enforce_private_link_endpoint_network_policies]
  }
}
