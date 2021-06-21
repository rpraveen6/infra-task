resource "azurerm_resource_group" "k8s" {
  name     = var.resource_group
  location = var.location
}

resource "random_string" "randomstr" {
  length = 10
}
