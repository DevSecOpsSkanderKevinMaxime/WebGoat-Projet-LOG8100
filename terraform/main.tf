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
resource "kubernetes_deployment" "development_example" {
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
        node_selector = {
          environment = "development" # Ensure this deployment runs on development nodes
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
resource "kubernetes_deployment" "production_example" {
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
        node_selector = {
          environment = "production" # Ensure this deployment runs on production nodes
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
