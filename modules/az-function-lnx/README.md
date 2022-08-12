## Linux

./modules/az-function-lnx
- Uses azurerm azurerm_linux_function_app
- Linux function requires a Linux App Service Plan
- Linux supports the following options, so you have to provide the version of the application stack you want to use when calling the module.
      python_version = var.python_version		Possible values include 3.6, 3.7, 3.8, and 3.9
      dotnet_version = var.dotnet_version		Possible values include 3.1 and 6.0
      node_version   = var.node_version1		Possible values include 12, 14, and 16.

## Windows

./modules/az-function-win
- Uses azurerm azurerm_windows_function_app
- Windows function requires a Windows App Service Plan
- Windows support the following options, so you have to provide the version of the application stack you want to use when calling the module.
      java_version   = var.java_version		Supported versions include 8, and 11
      dotnet_version = var.dotnet_version     	Possible values include 3.1 and 6
      node_version   = var.node_version		Possible values include ~12, ~14, and ~16

## Inputs

| Name | Description | Type | Required | Windows/Linux |
|------|-------------|------|---------|:--------:|
| resource_group_name| Name or resource Group | `string` | yes | both |
| location| Location of resources and resource group | `string` | yes | both |
| azurerm_app_service_id| App Service Plan ID for either Windows or Linux | `string` | yes | OS Specific |
| pep_name | Name of Private End Point for Function App | `string` | yes | both |
| pep_subnet_id | Subnet ID for Private EndPoint Subnet | `string` | yes | both |
| swift_subnet_id | Function Swift Subnet ID - Function Outbound | `string` | yes | both |
| func_dns_id| Private DNS ID for privatelink.azurewebsites.net | `string` | yes | both |
| file_dns_id| Private DNS ID for privatelink.file.core.windows.net | `string` | yes | both |
| blob_dns_id| Private DNS ID for privatelink.blob.core.windows.net | `string` | yes | both |
| queue_dns_id| Private DNS ID for privatelink.queue.core.windows.net | `string` | yes | both |
| table_dns_id| Private DNS ID for privatelink.table.core.windows.net | `string` | yes | both |
| func_app_storage_name| Unique name of Storage Account for the Function| `string` | yes | both |
| storage_account_networksetting| Storage Account Network Setting - Set to Deny | `bool` | yes | both |
| log_analytics_ws_id| Log Analytics Workspace ID | `string` | no | both |
| func_diag_logs| Function Category details for Azure Diagnostic setting | `list` | yes | both |
| func_name| Name of Function App | `string` | yes | both |
| functions_extension_version| The runtime version associated with the Function App | `string` | yes | both |
| application_insights_connection_string| App Insight connection string | `string` | no | both |
| application_insights_key| App Insight Key | `string` | no | both |
| dotnet_version| The version of .NET to use. Possible values include 3.1 and 6 | `number` | at least 1 | both |
| java_version| The Version of Java to use. Supported versions include 8, and 11 | `number` | at least 1 | both |
| node_version| The version of Node to run. Possible values include (Windows:~12, ~14, and ~16)(Linux:12, 14, and 16) | `number` | at least 1 | both |
| python_version | The version of Python to run. Possible values include 3.6, 3.7, 3.8, and 3.9 | `number` | at least 1 | Linux |

## Outputs

| Name | Description | Windows/Linux |
|------|-------------|---------------|
| linux_function_identity_id | Managed Idenentity ID for Linux Function App | Linux |
| linux_function_id | Linux Funciton App ID | Linux |
| linux_function_storage_account_id | Storage Account for Linux Function ID | Linux |
| windows_function_identity_id | Managed Idenentity ID for Windows Function App | Windows |
| windows_function_id | Windows Funciton App ID | Windows |
| windows_function_storage_account_id | Storage Account for Windows Function ID | Windows |
