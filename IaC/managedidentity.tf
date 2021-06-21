resource "azurerm_user_assigned_identity" "managed_identity" {
  resource_group_name = azurerm_resource_group.k8s.name
  location            = azurerm_resource_group.k8s.location

  name = var.managed_identity_name
}