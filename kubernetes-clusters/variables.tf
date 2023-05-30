variable "resource_group_name" {
  description = "(required) Name of the target Resource Group"
  type        = string
}

variable "dns_zone_id" {
  description = "(required) ID of the DNS Zone"
  type        = string
}

variable "enable_log_analytics" {
  description = "(optional) Enable log analytics for Kubernetes cluster"
  type        = bool
  default     = false
}

variable "log_analytics_workspace_name" {
  description = "(optional) Name prefix of the log analytics workspace"
  type        = string
  default     = "aks-loganalyticsws"
}

variable "log_analytics_workspace_sku" {
  description = "(optional) SKU type of log analytics workspace"
  type        = string
  default     = "PerGB2018"
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

variable "add_gpu_node_pool" {
  description = "(required) Option to add or not GPU node pool"
  type        = bool
  default     = false
}

variable "gpu_node_pool_name" {
  description = "(required) Name of the GPU node pool for Kubernetes Cluster"
  type        = string
  default     = "gpupool"
}

# https://learn.microsoft.com/en-us/azure/virtual-machines/sizes-general
variable "gpu_node_pool_vm_size" {
  description = "(required) Size of virtual machine for GPU node pool"
  type        = string
}

variable "gpu_node_pool_min_count" {
  description = "(optional) Minimum number of GPU nodes"
  type        = number
  default     = 0
}

variable "gpu_node_pool_max_count" {
  description = "(optional) Maximum number of GPU nodes"
  type        = number
  default     = 3
}

variable "add_aial_node_pool" {
  description = "(optional) Option to add AIAL GPU node pool for plus-minus-click"
  type        = bool
  default     = false
}

variable "aial_node_pool_name" {
  description = "(optional) Name of the AIAL GPU node pool for Kubernetes Cluster"
  type        = string
  default     = "aialpool"
}

# https://learn.microsoft.com/en-us/azure/virtual-machines/sizes-general
variable "aial_node_pool_vm_size" {
  description = "(required) Size of virtual machine for AIAL GPU node pool"
  type        = string
}

variable "aial_node_pool_min_count" {
  description = "(optional) Minimum number of AIAL GPU nodes"
  type        = number
  default     = 0
}

variable "aial_node_pool_max_count" {
  description = "(optional) Maximum number of AIAL GPU nodes"
  type        = number
  default     = 3
}

variable "workers_subnet_id" {
  description = "(required) Node pool subnet id"
  type        = string
}

variable "name_prefix" {
  description = "(required) Resource Name Prefix"
  type        = string
}

variable "name_suffix" {
  description = "(required) Resource Name Suffix"
  type        = string
}

variable "user_assigned_identity_id" {
  description = "(required) User Assigned Identity ID"
  type        = string
}