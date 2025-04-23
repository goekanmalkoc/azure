provider "azurerm" {
  features {}

}

resource "azurerm_resource_group" "rg" {
  name     = "flask-terraform-rg"
  location = "West Europe"
}

resource "azurerm_app_service_plan" "asp" {
  name                = "flask-asp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku {
    tier = "Free"
    size = "F1"
  }

  reserved = true # Linux için
}

resource "azurerm_app_service" "app" {
  name                = "flask-terraform-app"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.asp.id

  site_config {
    linux_fx_version = "PYTHON|3.10"
  }

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "1"
  }
}
