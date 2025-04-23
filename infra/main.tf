resource "azurerm_resource_group" "archie-dev" {
  name     = var.resource_group_name
  location = var.location
}
