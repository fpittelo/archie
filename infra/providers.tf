# providers.tf

terraform {
  backend "azurerm" {
    use_oidc             = true
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.2"  // Pin the provider version per best practices
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.3"  // Pin the provider version per best practices
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
  use_oidc = true
}

provider "azuread" {
  use_oidc = true
}