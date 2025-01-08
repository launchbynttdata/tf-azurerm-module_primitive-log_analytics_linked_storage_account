resource_names_map = {
  resource_group = {
    name       = "rg"
    max_length = 80
  }
  storage_account = {
    name       = "sa"
    max_length = 24
  }
  log_analytics_workspace = {
    name       = "law"
    max_length = 80
  }
}
logical_product_family  = "launch"
logical_product_service = "storage"
region                  = "eastus"
data_source_type        = "CustomLogs"
tags = {
  Purpose = "Terratest"
}
