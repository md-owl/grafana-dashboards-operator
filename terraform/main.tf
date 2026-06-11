# Module for creating a single ConfigMap with all dashboard JSON files
module "dashboards_configmap" {
  source         = "./modules/dashboards-configmap"
  namespace      = "monitoring"
  configmap_name = "dashboards"
  json_directory = "../json"
}