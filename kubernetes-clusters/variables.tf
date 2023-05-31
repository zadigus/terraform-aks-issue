variable "resource_group_name" {
  description = "(required) Name of the target Resource Group"
  type        = string
}

variable "dns_zone_id" {
  description = "(required) ID of the DNS Zone"
  type        = string
}

variable "location" {
  description = "(required) Region to create the Kubernetes Cluster"
  type        = string
  default     = "eastus"
}

variable "name" {
  description = "(required) Name of the Kubernetes Cluster"
  type        = string
}

variable "dns_prefix" {
  description = "(required) Name prefix of the Kubernetes Cluster DNS"
  type        = string
}

variable "sku_tier" {
  description = "(optional) SKU Tier"
  type        = string
  default     = "Standard"
}

variable "tags" {
  description = "(optional) Some useful information"
  type        = map(any)
  default     = {}
}

variable "kubernetes_version" {
  description = "(required) Kubernetes version (e.g. 1.21.9)"
  type        = string
}

# https://learn.microsoft.com/en-us/azure/virtual-machines/sizes-general
variable "cpu_node_pool_vm_size" {
  description = "(required) Size of virtual machine for CPU node pool"
  type        = string
}

variable "cpu_node_pool_min_count" {
  description = "(required) Minimal number of CPU nodes"
  type        = string
}

variable "cpu_node_pool_max_count" {
  description = "(required) Maximal number of CPU nodes"
  type        = string
}

variable "workers_subnet_id" {
  description = "(required) Node pool subnet id"
  type        = string
}

variable "user_assigned_identity_id" {
  description = "(required) User Assigned Identity ID"
  type        = string
}