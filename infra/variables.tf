variable "resource_group_name" {
  type    = string
  default = coalesce(var.environment["AZURE_RESOURCE_GROUP_NAME"], "rg-tf-test")
}

variable "location" {
  type    = string
  default = coalesce(var.environment["AZURE_LOCATION"], "switzerlandnorth")
}

variable "environment" {
  type    = map(string)
  default = tomap({})
}
