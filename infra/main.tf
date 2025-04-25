resource "azurerm_resource_group" "archie-dev" {
  name                = var.resource_group_name
  location            = var.location
}

resource "azurerm_static_web_app" "archie-webapp" {
  depends_on          = [azurerm_resource_group.archie-dev]
  name                = var.swebapp_name
  resource_group_name = var.resource_group_name
  location            = var.location_eu
}

output "static_web_app_api_key" {
  value = azurerm_static_web_app.archie-webapp.api_key
  sensitive = true
  description = "API key for the static web app"
}

output "static_web_app_default_host_name" {
  value = azurerm_static_web_app.archie-webapp.default_host_name
  description = "Default host name for the static web app"
}