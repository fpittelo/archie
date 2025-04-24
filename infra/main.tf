resource "azurerm_resource_group" "archie-dev" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_static_web_app" "archie-webapp" {
  name                  = var.swebapp_name
  resource_group_name   = var.resource_group_name
  location              = var.location
  sku_tier              = var.sku_tier
  sku_size              = var.sku_size
  repository_url        = var.repository_url
  repository_branch     = var.branch_name

  identity {
    type = "SystemAssigned"
  }

}