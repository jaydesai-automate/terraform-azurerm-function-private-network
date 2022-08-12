variable "location" {
  description = "Azure Location "
  type        = string
}

variable "resource_group_name" {
  description = "Resouce Group Name"
  type        = string
}

variable "azurerm_app_service_id" {
  description = "App Service ID"
  type        = string
}

variable "pep_name" {
  description = "Name of Private End Point for Function"
  type        = string
}

variable "private_service_name" {
  description = "Service Name of Private End Point"
  type        = string

}

variable "pep_subnet_id" {
  description = "Subnet ID for Private EndPoint Subnet"
  type        = string

}



variable "swift_subnet_id" {
  description = "Function Swift Subnet ID"
  type        = string

}


variable "func_dns_id" {
  description = "Private DNS ID for privatelink.azurewebsites.net"
  type        = string
}

variable "file_dns_id" {
  description = "Private DNS ID for privatelink.file.core.windows.net"
  type        = string

}
variable "blob_dns_id" {
  description = "Private DNS ID for privatelink.blob.core.windows.net"
  type        = string

}
variable "queue_dns_id" {
  description = "Private DNS ID for privatelink.queue.core.windows.net"
  type        = string

}
variable "table_dns_id" {
  description = "Private DNS ID for privatelink.table.core.windows.net"
  type        = string

}

variable "func_app_storage_name" {
  description = "Name for Storage"
  type        = string
}

variable "storage_account_networksetting" {
  description = "Storage Account Network Setting"
  default     = "Deny"
}

variable "log_analytics_ws_id" {
  description = "Log Analytics Workspace ID"
  default     = null
}

variable "func_diag_logs" {
  description = "Function Category details for Azure Diagnostic setting"
  default     = ["FunctionAppLogs"]
}

variable "func_name" {
  description = "Name of Function"
  type        = string
}

variable "functions_extension_version" {
  description = "Function Version"
  default     = "~4"
}

variable "java_version" {
  description = "java version"
  default = null
}
variable "dotnet_version" {
  description = "dotnet version"
  default = null
}
variable "node_version" {
  description = "node version"
  default = null
}

variable "application_insights_connection_string" {
  description = "App Insight connection string"
  type        = string
  default     = null
}

variable "application_insights_key" {
  description = "App Insight Key"
  type        = string
  default     = null
}
