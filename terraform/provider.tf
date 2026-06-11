# Provider configuration for Kubernetes and GitLab

terraform {
  required_version = ">= 1.0"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0"
    }
  }
  backend "consul" {
    address = "consul-prod.media.mts.ru"
    path    = "media-ai/grafana-dashboards-configmaps-tfstate"
    scheme  = "https"
  }
}
# Configure the Kubernetes Provider
provider "kubernetes" {
  # When running in a Kubernetes pod with a service account,
  # the Kubernetes provider will automatically use the pod's service account
  # if no explicit configuration is provided
  config_path = var.kubeconfig_path != "" ? var.kubeconfig_path : null
}