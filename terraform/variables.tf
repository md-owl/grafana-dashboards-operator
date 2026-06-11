# Variables for the Terraform configuration

variable "namespace" {
  description = "The namespace where ConfigMaps will be created"
  type        = string
  default     = "monitoring"
}

variable "kubeconfig_path" {
  description = "Path to kubeconfig file (empty when using service account)"
  type        = string
  default     = ""
}