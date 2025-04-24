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

variable "repository_token" {
  type        = string
  description = "The repository token for the static web app. This should be set via GitHub Actions secrets."
}

variable "sku_tier" {
  type = string
}

variable "sku_size" {
  type = string
}