resource "azurerm_resource_group" "archie-dev" {
  name                = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

resource "azurerm_static_web_app" "archie-webapp" {
  depends_on          = [azurerm_resource_group.archie-dev]
  name                = var.swebapp_name
  resource_group_name = var.resource_group_name
  location            = var.location_eu
  tags                = var.tags
}

resource "azurerm_linux_function_app" "archie-functionapp" {
  name                = var.function_app_name
  resource_group_name = var.resource_group_name
  location            = var.location_eu


  service_plan_id = azurerm_service_plan.archie-appserviceplan.id

  storage_account_name   = azurerm_storage_account.archie-storageaccount.name
  storage_account_access_key = azurerm_storage_account.archie-storageaccount.primary_access_key

  site_config {
  # linux_fx_version = "python|${var.function_app_runtime}"
  }

  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME" = "python"
    "OPENAI_API_KEY"           = var.openai_api_key # Use the variable to get the API key
    "AzureWebJobsStorage"      = azurerm_storage_account.archie-storageaccount.primary_connection_string
  }

  depends_on = [
    azurerm_service_plan.archie-appserviceplan,
    azurerm_storage_account.archie-storageaccount,
    azurerm_resource_group.archie-dev
  ]
}

resource "azurerm_service_plan" "archie-appserviceplan" {
  depends_on          = [azurerm_resource_group.archie-dev]
  name                = "archie-appserviceplan"
  location            = var.location_eu
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_storage_account" "archie-storageaccount" {
  depends_on               = [azurerm_resource_group.archie-dev]
  name                     = var.sa_name
  resource_group_name      = var.resource_group_name
  location                 = var.location_eu
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_key_vault" "archie-keyvault" {
  name                        = var.az_keyvault_name
  location                    = var.location_eu
  resource_group_name         = var.resource_group_name
  tenant_id                   = var.az_tenant_id
  sku_name                    = "standard"
  soft_delete_retention_days  = 7
  purge_protection_enabled    = true


  access_policy {
    tenant_id = var.az_tenant_id
    object_id = var.az_object_id

    key_permissions = [
      "Get",
      "List",
      "Create",
      "Update",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
      "Purge",
    ]

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
      "Purge",
    ]

    storage_permissions = [
      "Get",
      "List",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
      "Purge",
    ]
  }
}

output "static_web_app_api_key" {
  value       = azurerm_static_web_app.archie-webapp.api_key
  sensitive   = true
  description = "API key for the static web app"
}

output "static_web_app_default_host_name" {
  value       = azurerm_static_web_app.archie-webapp.default_host_name
  description = "Default host name for the static web app"
}

output "function_app_endpoint" {
  value       = "https://${azurerm_linux_function_app.archie-functionapp.default_hostname}/api/YourFunction" # Adjust the function name
  description = "Endpoint URL for the Azure Function App"
}