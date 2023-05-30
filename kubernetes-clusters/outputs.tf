output "kubernetes_cluster_id" {
  value = azurerm_kubernetes_cluster.cluster.id
}

output "node_resource_group_name" {
  value = azurerm_kubernetes_cluster.cluster.node_resource_group
}

output "kubernetes_principal_id" {
  value = azurerm_kubernetes_cluster.cluster.kubelet_identity.0.object_id
}

output "kubernetes_client_certificate" {
  value = base64decode(azurerm_kubernetes_cluster.cluster.kube_config.0.client_certificate)
  sensitive = true
}

output "kubernetes_client_key" {
  value = base64decode(azurerm_kubernetes_cluster.cluster.kube_config.0.client_key)
  sensitive = true
}

output "kubernetes_cluster_ca_certificate" {
  value = base64decode(azurerm_kubernetes_cluster.cluster.kube_config.0.cluster_ca_certificate)
  sensitive = true
}

output "kubernetes_host" {
  value = azurerm_kubernetes_cluster.cluster.kube_config.0.host
  sensitive = true
}