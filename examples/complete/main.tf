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

module "resource_names" {
  source  = "terraform.registry.launch.nttdata.com/module_library/resource_name/launch"
  version = "~> 2.0"

  for_each = var.resource_names_map

  logical_product_family  = var.logical_product_family
  logical_product_service = var.logical_product_service
  region                  = join("", split("-", var.region))
  class_env               = var.environment
  cloud_resource_type     = each.value.name
  instance_env            = var.environment_number
  instance_resource       = var.resource_number
  maximum_length          = each.value.max_length
}

module "resource_group" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/resource_group/azurerm"
  version = "~> 1.0"

  name       = module.resource_names["resource_group"].minimal_random_suffix
  location   = var.region
  tags       = local.tags
  managed_by = var.managed_by
}

module "storage_account" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/storage_account/azurerm"
  version = "~> 1.3"

  resource_group_name  = module.resource_group.name
  location             = var.region
  storage_account_name = module.resource_names["storage_account"].minimal_random_suffix_without_any_separators
  tags                 = local.tags

  depends_on = [module.resource_group]
}

module "log_analytics_workspace" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/log_analytics_workspace/azurerm"
  version = "~> 1.1"

  name                = module.resource_names["log_analytics_workspace"].minimal_random_suffix
  resource_group_name = module.resource_group.name
  location            = var.region
  sku                 = var.law_sku
  retention_in_days   = var.law_retention_in_days
  tags                = local.tags

  depends_on = [module.resource_group]
}

module "linked_storage" {
  source = "../.."

  data_source_type      = var.data_source_type
  resource_group_name   = module.resource_group.name
  workspace_resource_id = module.log_analytics_workspace.id
  storage_account_ids   = [module.storage_account.id]
}
