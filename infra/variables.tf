variable "environment" {
  type    = map(string)
  default = {}
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "backend_rg_name" {
  type        = string
}

variable "backend_sa_name" {
  type        = string
}

variable "backend_container_name" {
  type        = string
}

variable "swebapp_name" {
  type = string
}

variable "branch_name" {
  type = string
}

variable "repository_url" {
  type = string
}

variable "sku_tier" {
  type = string
}

variable "sku_size" {
  type = string
}