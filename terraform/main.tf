# resource "null_resource" "start_minikube" {
#   provisioner "local-exec" {
#     command = "minikube start --driver=docker --nodes=2"
#   }

#   # Ensure that Minikube is started before we proceed with setting up nodes
#   triggers = {
#     minikube = "started"
#   }
# }

# resource "null_resource" "setup_nodes" {
#   provisioner "local-exec" {
#     command = "./setup_nodes.sh"
#   }

#   # Optional: add dependency on Kubernetes namespace or deployments to ensure nodes are available
#   depends_on = [kubernetes_namespace.development, kubernetes_namespace.production]
# }

# Create namespace for deployment (development)
resource "kubernetes_namespace" "development" {
  metadata {
    name = "k8s-ns-development"
  }
}

# Create namespace for production
resource "kubernetes_namespace" "production" {
  metadata {
    name = "k8s-ns-production"
  }
}

# Deployment configuration for Development environment
resource "kubernetes_deployment" "development" {
  metadata {
    name      = "webgoat-development"
    labels    = { test = "webgoat" }
    namespace = kubernetes_namespace.development.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = { test = "webgoat" }
    }

    template {
      metadata {
        labels = { test = "webgoat" }
      }

      spec {
        # Node selector for development node
        node_selector = {
          environment = "development" # Runs on nodes labeled with "environment=development"
        }

        container {
          image = "log8100projet/projetfinal:feature-Partie1-GithubAction-BuildTestDeploiement"
          name  = "webgoat"

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
          port {
            container_port = 8080
          }
        }
      }
    }
  }
}

# Development service for Development environment
resource "kubernetes_service" "webgoat_development" {
  metadata {
    name      = "webgoat-service-development"
    namespace = kubernetes_namespace.development.metadata[0].name
  }

  spec {
    selector = { test = "webgoat" }
    port {
      port        = 80
      target_port = 8080
    }
    type = "NodePort"
  }
}

# Deployment configuration for Production environment
resource "kubernetes_deployment" "production" {
  metadata {
    name      = "webgoat-production"
    labels    = { test = "webgoat" }
    namespace = kubernetes_namespace.production.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = { test = "webgoat" }
    }

    template {
      metadata {
        labels = { test = "webgoat" }
      }

      spec {
        # Node selector for production node
        node_selector = {
          environment = "production" # Runs on nodes labeled with "environment=production"
        }

        container {
          image = "log8100projet/projetfinal:feature-Partie1-GithubAction-BuildTestDeploiement"
          name  = "webgoat"

          resources {
            limits = {
              cpu    = "1"
              memory = "1Gi"
            }
            requests = {
              cpu    = "500m"
              memory = "256Mi"
            }
          }
          port {
            container_port = 8080
          }
        }
      }
    }
  }
}

# Production service for Production environment
resource "kubernetes_service" "webgoat_production" {
  metadata {
    name      = "webgoat-service-production"
    namespace = kubernetes_namespace.production.metadata[0].name
  }

  spec {
    selector = { test = "webgoat" }
    port {
      port        = 80
      target_port = 8080
    }
    type = "NodePort"
  }
}
