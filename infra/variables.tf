# infra/variables.tf

variable "environment" {
  type    = string
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
  sensitive   = true # Keep sensitive if it's a PAT, less so if it's just the URL
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

variable "app_insights_name" {
  type        = string
  description = "The name for the Application Insights instance."
}

variable "openai_api_key" {
  type        = string
  description = "The OpenAI API key. Must be set via Github secrets"
  sensitive   = true
}

variable "az_keyvault_name" {
  type = string
}

variable "az_tenant_id" {
  type        = string
  description = "The Azure Tenant ID. Must be set via Github secrets (AZURE_TENANT_ID)"
}

variable "az_subscription_id" {
  type        = string
  description = "The Azure Subscription ID. Must be set via Github secrets (AZURE_SUBSCRIPTION_ID)"
}

variable "az_object_id" {
  type        = string
  description = "The Object ID of the user or service principal running the deployment (e.g., GitHub Actions OIDC principal). Must be set via Github secrets"
  sensitive   = true # Object ID itself isn't secret, but good practice if used for permissions
}

variable "tags" {
  type = map(string)
  default = {
    owner       = "Fred"
    project     = "archie"
    costcenter  = "IT"
  }
}