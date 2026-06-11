variable "namespace" {
  description = "Namespace where the ConfigMap will be created"
  type        = string
  default     = "monitoring"
}

variable "configmap_name" {
  description = "Name of the ConfigMap to create"
  type        = string
  default     = "dashboards"
}

variable "json_directory" {
  description = "Path to the directory containing JSON dashboard files"
  type        = string
  default     = "../../json"
}

# Get all JSON files in the directory
locals {
  json_files = fileset(var.json_directory, "*.json")

  # Create a map with filename as key and file content as value
  dashboard_data = {
    for file in local.json_files :
    file => file("${var.json_directory}/${file}")
  }
}

resource "kubernetes_config_map_v1" "dashboards" {
  metadata {
    name      = var.configmap_name
    namespace = var.namespace
  }

  data = local.dashboard_data
}

output "configmap_name" {
  value = kubernetes_config_map_v1.dashboards.metadata[0].name
}

output "configmap_namespace" {
  value = kubernetes_config_map_v1.dashboards.metadata[0].namespace
}