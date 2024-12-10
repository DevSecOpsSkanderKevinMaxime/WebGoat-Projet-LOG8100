terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.00"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"  # Emplacement du fichier de configuration de Minikube
}
