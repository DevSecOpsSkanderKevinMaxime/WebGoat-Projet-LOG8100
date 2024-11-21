# Variables for reusability and cleaner configuration
variable "namespace_development" {
  default = "development"
}

variable "namespace_production" {
  default = "production"
}

variable "image" {
  default = "log8100projet/projetfinal:latest"
}

variable "app_name" {
  default = "webgoat"
}

# Define namespaces
resource "kubernetes_namespace" "development" {
  metadata {
    name = var.namespace_development
  }
}
