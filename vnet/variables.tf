variable "location" {
  description = "(required) Region to create the NSG"
  type        = string
}

variable "resource_group_name" {
  description = "(required) Name of the target Resource Group"
  type        = string
}

variable "aks_network" {
  description = "(required) Vnet / Subnets for AKS clusters"
  type        = object({
    vnet       = string
    workers_subnet = string
    ingress_subnet = string
  })
}

variable "tags" {
  description = "(optional) Some useful information"
  type        = map(any)
  default     = {}
}