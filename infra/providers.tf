# providers.tf

terraform {
  backend "azurerm" {
    resource_group_name  = var.backend_rg_name
    storage_account_name = var.backend_sa_name
    container_name       = var.backend_container_name
    key                  = "archie-${terraform.workspace}.tfstate"
    use_oidc             = true
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"  // Pin the provider version per best practices
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
      recover_soft_deleted_key_vaults = false
    }
  }
}