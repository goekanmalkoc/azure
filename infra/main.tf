terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.27.0"
    }
  }
}

provider "azurerm" {
  features {}

#   subscription_id = var.subscription_id
#   tenant_id       = var.tenant_id
#   client_id       = var.client_id
#   client_secret   = var.client_secret
}

resource "azurerm_resource_group" "rg" {
  name     = "flask-terraform-rg"
  location = "West Europe"
}

resource "azurerm_service_plan" "asp" {
  name                = "flask-asp"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "F1"
}

resource "azurerm_linux_web_app" "app" {
  name                = "flask-terraform-app"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    always_on = false
      application_stack {
    python_version = "3.12"
  }
  }


  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    "MY_SETTING" = "some-value"
  }
}


