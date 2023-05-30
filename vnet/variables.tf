variable "location" {
  description = "(required) Region to create the NSG"
  type        = string
}

variable "resource_group_name" {
  description = "(required) Name of the target Resource Group"
  type        = string
}

variable "subnet_nsg_id" {
  description = "(required) Private Network Security Group Id of the Subnet"
  type        = string
}

variable "aks_idx" {
  description = "(required) AKS cluster index"
  type        = number
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