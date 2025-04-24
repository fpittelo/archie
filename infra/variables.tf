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