variable "resource_group_name" {
  description = "(required) Name of the target Resource Group"
  type        = string
}

variable "resource_group_id" {
  description = "(required) ID of the target Resource Group"
  type        = string
}

variable "location" {
  description = "(required) Location of Storage Account deployment"
  type        = string
  default     = "eastus"
}

variable "aks_vnet_id" {
  description = "(required) The ID of the AKS VNet"
  type        = string
}

variable "dns_zone_id" {
  description = "(required) The ID of the AKS DNS Zone"
  type        = string
}

variable "tags" {
  description = "(optional) Some useful information"
  type        = map(any)
  default     = {}
}