# Outputs for the Terraform configuration

output "created_configmaps" {
  description = "List of ConfigMaps created with their names and namespaces"
  value = [{
    name      = module.dashboards_configmap.configmap_name
    namespace = module.dashboards_configmap.configmap_namespace
  }]
}

output "configmap_names" {
  description = "Names of ConfigMaps created"
  value       = [module.dashboards_configmap.configmap_name]
}