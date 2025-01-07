// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

output "id" {
  description = "The ID of the linked storage account."
  value       = azurerm_log_analytics_linked_storage_account.storage.id
}

output "data_source_type" {
  description = "The data source type of the linked storage account."
  value       = azurerm_log_analytics_linked_storage_account.storage.data_source_type
}

output "storage_account_ids" {
  description = "The list of storage account IDs linked to the Log Analytics workspace."
  value       = azurerm_log_analytics_linked_storage_account.storage.storage_account_ids
}
