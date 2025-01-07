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

output "resource_group_name" {
  description = "The name of the resource group."
  value       = module.resource_group.name
}

output "storage_account_id" {
  description = "The ID of the storage account."
  value       = module.storage_account.id
}

output "workspace_name" {
  description = "The name of the Log Analytics workspace."
  value       = module.log_analytics_workspace.name
}

output "workspace_id" {
  description = "The ID of the Log Analytics workspace."
  value       = module.log_analytics_workspace.id
}

output "linked_storage_account_id" {
  description = "The ID of the linked storage account."
  value       = module.linked_storage.id
}

output "linked_storage_account_data_source_type" {
  description = "The data source type of the linked storage account."
  value       = module.linked_storage.data_source_type
}
