variable "resource_group_name" {
  description = "(required) Name of the target Spoke Resource Group"
  type        = string
}

variable "tags" {
  description = "(optional) Some useful information"
  type        = map(any)
  default     = {}
}