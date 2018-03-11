output "app_insights_key" {
  value = "${azurerm_application_insights.dev.instrumentation_key}"
}

output "app_insights_app_id" {
  value = "${azurerm_application_insights.dev.app_id}"
}

output "storage_name" {
  value = "${azurerm_storage_account.dev.name}"
}

output "storage_key" {
  value = "${azurerm_storage_account.dev.primary_access_key}"
}
