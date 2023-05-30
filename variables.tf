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

variable "aks_idx" {
  description = "(required) Index of the AKS cluster"
  type        = number
}

###########################################################
#  Hub VNet Variables
###########################################################
variable "hub_vnet_id" {
  description = "(required) ID of the hub virtual network"
  type        = string
}

variable "hub_vnet_name" {
  description = "(required) Name of the hub virtual network"
  type        = string
}

variable "hub_resource_group_name" {
  description = "(required) Name of the Hub Resource Group"
  type        = string
}

###########################################################
#  AKS VNet Variables
###########################################################
variable "aks_vnet" {
  description = "(required) IP Range of the AKS virtual network"
  type        = string
}

###########################################################
#  Role Assignments Variables
###########################################################
variable "acr_id" {
  description = "(required) ACR ID"
  type        = string
}

###########################################################
#  DNS Zones Variables
###########################################################
variable "acr_dns_zone_name" {
  description = "(required) ACR DNS zone name"
  type        = string
}

variable "psql_dns_zone_name" {
  description = "(required) PSQL DNS zone name"
  type        = string
}

variable "blob_dns_zone_name" {
  description = "(required) Blob DNS zone name"
  type        = string
}

###########################################################
#  Route Tables Variables
###########################################################
variable "fw_private_ip_address" {
  description = "(required) Private IP address of the firewall"
  type        = string
}

###########################################################
#  Kubernetes Clusters Variables
###########################################################
variable "enable_log_analytics" {
  description = "(optional) Enable log analytics for Kubernetes cluster"
  type        = bool
  default     = false
}

variable "log_analytics_workspace_sku" {
  description = "SKU type of log analytics workspace"
  type        = string
  default     = "PerGB2018"
}

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

###########################################################
#  Kubernetes Clusters GPU Node Pool Variables
###########################################################
variable "add_gpu_node_pool" {
  description = "(optional) Option to add or not GPU node pool"
  type        = bool
  default     = false
}

variable "aks_gpu_node_pool_name" {
  description = "(optional) Name of the GPU node pool for Kubernetes Cluster"
  type        = string
  default     = "gpupool"
}

variable "aks_gpu_node_pool_vm_size" {
  description = "(required) Size of virtual machine for GPU node pool"
  type        = string
}

variable "aks_gpu_node_pool_min_count" {
  description = "(optional) Minimum number of GPU nodes"
  type        = number
  default     = 0
}

variable "aks_gpu_node_pool_max_count" {
  description = "(optional) Maximum number of GPU nodes"
  type        = number
  default     = 3
}

variable "add_aial_node_pool" {
  description = "(required) Option to add or not GPU node pool"
  type        = bool
  default     = false
}

variable "aks_aial_node_pool_name" {
  description = "(required) Name of the AIAL GPU node pool for Kubernetes Cluster"
  type        = string
  default     = "aialpool"
}

variable "aks_aial_node_pool_vm_size" {
  description = "(required) Size of virtual machine for AIAL GPU node pool"
  type        = string
}

variable "aks_aial_node_pool_min_count" {
  description = "(optional) Minimum number of AIAL GPU nodes"
  type        = number
  default     = 0
}

variable "aks_aial_node_pool_max_count" {
  description = "(optional) Maximum number of AIAL GPU nodes"
  type        = number
  default     = 3
}

###########################################################
#  Nginx Ingress Controller Variables
###########################################################
variable "ingress_controller_namespace" {
  description = "(required) Name of the ingress controller namespace"
  type        = string
}

variable "nginx_ingress_helm_chart_version" {
  description = "(required) Nginx Ingress Controller Helm Chart version"
  type        = string
}

variable "ilb_pls_id" {
  description = "(optional) ID of the ILB PLS"
  type        = string
  default     = ""
}