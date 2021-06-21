output "aks_resource_group" {
  value = azurerm_resource_group.k8s.name
}

output "aks_cluster_name" {
  value = "${var.aks-prefix}-aks"
}

output "managed_identity_resource_id" {
  value = azurerm_user_assigned_identity.managed_identity.id
}

output "managed_identity_client_id" {
  value = azurerm_user_assigned_identity.managed_identity.client_id
}

output "managed_identity_principal_id" {
  value = azurerm_user_assigned_identity.managed_identity.principal_id
}

output "aks_host"{
  value = azurerm_kubernetes_cluster.aks.fqdn
}

output "aks_node_resource_group" {
  value = azurerm_kubernetes_cluster.aks.node_resource_group
}

output "acr_name" {
  description = "Login Server for ACR"
  value = azurerm_container_registry.acr.name
}