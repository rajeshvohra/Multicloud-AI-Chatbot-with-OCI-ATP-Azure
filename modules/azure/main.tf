provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-rag-chatbot"
  location = "West US 2"
}

resource "azurerm_storage_account" "sa" {
  name                     = "ragchatbotstore${random_id.suffix.hex}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "docs" {
  name                  = "documents"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}

resource "azurerm_cognitive_account" "openai" {
  name                = "ragchatbot-openai"
  location            = azurerm_resource_group.rg.location
  kind                = "OpenAI"
  sku_name            = "S0"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_app_service_plan" "plan" {
  name                = "ragchatbot-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku {
    tier = "Free"
    size = "F1"
  }
}

resource "azurerm_app_service" "app" {
  name                = "ragchatbot-app"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.plan.id
  site_config {
    app_settings = {
      "AZURE_OPENAI_ENDPOINT" = azurerm_cognitive_account.openai.endpoint
    }
  }
}
