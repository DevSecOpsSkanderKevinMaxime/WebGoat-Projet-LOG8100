
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
          image = "log8100projet/projetfinal:latest"
          name  = "webgoat"
          resources {
            requests = {
              cpu    = "500m"
              memory = "512Mi"
            }
            limits = {
              cpu    = "1"
              memory = "1Gi"
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
      port        = 8080
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
          image = "log8100projet/projetfinal:latest"
          name  = "webgoat"
          resources {
            requests = {
              cpu    = "500m"
              memory = "512Mi"
            }
            limits = {
              cpu    = "1"
              memory = "1Gi"
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
      port        = 8080
      target_port = 8080
    }
    type = "NodePort"
  }
}
