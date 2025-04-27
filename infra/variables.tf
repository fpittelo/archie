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

variable "location_eu" {
  type = string
}

variable "backend_rg_name" {
  type        = string
}

variable "backend_sa_name" {
  type        = string
}

variable "sa_name" {
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

variable "function_app_name" {
  type = string
}

variable "function_app_runtime" {
  type    = string
  default = "3.9"
}

variable "openai_api_key" {
  type        = string
  description = "The OpenAI API key.  Must be set via Github secrets"
  sensitive   = true
}

variable "az_keyvault_name" {
  type = string
}

variable "az_tenant_id" {
  type        = string
  description = "The Azure Tenant ID. Must be set via Github secrets"
  sensitive   = true
}

variable "az_object_id" {
  type        = string
  description = "The Object ID of the user or service principal. Must be set via Github secrets"
  sensitive   = true
}