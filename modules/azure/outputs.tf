output "azure_app_url" {
  description = "URL of the deployed Azure App Service chatbot"
  value       = azurerm_app_service.app.default_site_hostname
}
