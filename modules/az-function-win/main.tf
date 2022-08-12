## Private Windows Azure Function ##

##Function with Private Storage
##Creates A storage Account with 4 Endpoints
##Storage Account
resource "azurerm_storage_account" "storage_account_function" {
  name                            = var.func_app_storage_name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_tier                    = "Standard"
  account_replication_type        = "GRS"
  allow_nested_items_to_be_public = false
  network_rules {
    default_action             = var.storage_account_networksetting
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }
}

##Blob EndPoint
resource "azurerm_private_endpoint" "storage_blob" {
  name                = "pep-${var.func_app_storage_name}-blob"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.pep_subnet_id
  private_service_connection {
    name                           = "psc-${var.func_app_storage_name}-blob"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.storage_account_function.id
    subresource_names              = ["blob"]
  }
  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [var.blob_dns_id]
  }
}

##Queue EndPoint
resource "azurerm_private_endpoint" "storage_queue" {
  name                = "pep-${var.func_app_storage_name}-queue"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.pep_subnet_id
  private_service_connection {
    name                           = "psc-${var.func_app_storage_name}-queue"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.storage_account_function.id
    subresource_names              = ["queue"]
  }
  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [var.queue_dns_id]
  }
}

##Table EndPoint
resource "azurerm_private_endpoint" "storage_table" {
  name                = "pep-${var.func_app_storage_name}-table"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.pep_subnet_id
  private_service_connection {
    name                           = "psc-${var.func_app_storage_name}-table"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.storage_account_function.id
    subresource_names              = ["table"]
  }
  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [var.table_dns_id]
  }
}

##File EndPoint
resource "azurerm_private_endpoint" "storage_file" {
  name                = "pep-${var.func_app_storage_name}-file"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.pep_subnet_id
  private_service_connection {
    name                           = "psc-${var.func_app_storage_name}-file"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.storage_account_function.id
    subresource_names              = ["file"]
  }
  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [var.file_dns_id]
  }
}

##Function 
resource "azurerm_windows_function_app" "function" {
  name                 = var.func_name
  resource_group_name  = var.resource_group_name
  location             = var.location
  service_plan_id      = var.azurerm_app_service_id
  storage_account_name = azurerm_storage_account.storage_account_function.name
  storage_uses_managed_identity = true
  identity {
    type = "SystemAssigned"
  }
  functions_extension_version   = var.functions_extension_version
  site_config {
    application_stack {
      java_version   = var.java_version
      dotnet_version = var.dotnet_version
      node_version   = var.node_version
    }
    application_insights_connection_string = var.application_insights_connection_string
    application_insights_key               = var.application_insights_key
  }
 
  lifecycle {
    ignore_changes = [app_settings, tags]
  }
}

##Function App Private End Point

resource "azurerm_private_endpoint" "pep_funcapp" {
  name                = var.pep_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.pep_subnet_id
  private_service_connection {
    name                           = var.private_service_name
    is_manual_connection           = false
    private_connection_resource_id = azurerm_windows_function_app.function.id
    subresource_names              = ["sites"]
  }
  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [var.func_dns_id]
  }
}

##Function  App Vnet intergration
resource "azurerm_app_service_virtual_network_swift_connection" "netwrok_integration" {
  app_service_id = azurerm_windows_function_app.function.id
  subnet_id      = var.swift_subnet_id
}

##Function Diag Settings
resource "azurerm_monitor_diagnostic_setting" "diag_func" {
  name                       = "diag-${var.func_name}"
  target_resource_id         = azurerm_windows_function_app.function.id
  log_analytics_workspace_id = var.log_analytics_ws_id
  dynamic "log" {
    for_each = var.func_diag_logs
    content {
      category = log.value
      enabled  = true

    }
  }
  metric {
    category = "AllMetrics"

  }
  lifecycle {
    ignore_changes = [log, metric]
  }
}

##RABC Rights for Function to Storage Account

resource "azurerm_role_assignment" "functionToStorage1" {
  scope                = azurerm_storage_account.storage_account_function.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_windows_function_app.function.identity[0].principal_id
}

resource "azurerm_role_assignment" "functionToStorage2" {
  scope                = azurerm_storage_account.storage_account_function.id
  role_definition_name = "Storage Account Key Operator Service Role"
  principal_id         = azurerm_windows_function_app.function.identity[0].principal_id
}

resource "azurerm_role_assignment" "functionToStorage3" {
  scope                = azurerm_storage_account.storage_account_function.id
  role_definition_name = "Reader and Data Access"
  principal_id         = azurerm_windows_function_app.function.identity[0].principal_id
}
