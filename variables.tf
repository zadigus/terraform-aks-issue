###########################################################
#  Common Variables
###########################################################
variable "location" {
  description = "(required) Region to create the resource"
  type        = string
}

variable "ARM_CLIENT_ID" {
  description = "(required) Client ID for Azure app registration"
  type        = string
}

variable "ARM_CLIENT_SECRET" {
  description = "(required) Client secret for Azure app registration"
  type        = string
}

variable "ARM_TENANT_ID" {
  description = "(required) Tenant ID for Azure"
  type        = string
}

variable "ARM_SUBSCRIPTION_ID" {
  description = "(required) Subscription ID for Azure"
  type        = string
}

variable "jira_project_id" {
  description = "(required) Jira Project ID used as a suffix for most resource names"
  type        = string
}

variable "project_name" {
  description = "(required) Project name mostly used as a prefix for resource names"
  type        = string
}

variable "resource_group_tags" {
  description = "(optional) Some useful information"
  type        = map(any)
  default     = {}
}

###########################################################
#  AKS VNet Variables
###########################################################
variable "aks_vnet" {
  description = "(required) IP Range of the AKS virtual network"
  type        = string
}

###########################################################
#  Kubernetes Clusters Variables
###########################################################
variable "aks_sku_tier" {
  description = "(optional) SKU Tier"
  type        = string
  default     = "Standard"
}

variable "kubernetes_version" {
  description = "(required) Kubernetes version (e.g. 1.21.9)"
  type        = string
}

variable "aks_cpu_node_pool_vm_size" {
  description = "(required) Size of virtual machine for AIAL GPU node pool"
  type        = string
}

variable "aks_cpu_node_pool_min_count" {
  description = "(required) Minimal number of CPU nodes"
  type        = string
}

variable "aks_cpu_node_pool_max_count" {
  description = "(required) Maximal number of CPU nodes"
  type        = string
}