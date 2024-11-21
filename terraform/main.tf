resource "kubernetes_namespace" "production" {
  metadata {
    name = var.namespace_production
  }
}

# Deployments for development and production
resource "kubernetes_deployment" "development" {
  metadata {
    name      = var.namespace_development
    namespace = kubernetes_namespace.development.metadata[0].name
    labels = {
      app         = var.app_name
      environment = var.namespace_development
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app         = var.app_name
        environment = var.namespace_development
      }
    }

    template {
      metadata {
        labels = {
          app         = var.app_name
          environment = var.namespace_development
        }
      }

      spec {
        node_selector = {
          environment = var.namespace_development
        }

        container {
          image = var.image
          name  = var.app_name
          port {
            container_port = 8080
          }

          # readiness_probe {
          #   http_get {
          #     path = "/health"
          #     port = 8080
          #   }
          #   initial_delay_seconds = 5
          #   timeout_seconds       = 1
          # }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "production" {
  metadata {
    name      = var.namespace_production
    namespace = kubernetes_namespace.production.metadata[0].name
    labels = {
      app         = var.app_name
      environment = var.namespace_production
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app         = var.app_name
        environment = var.namespace_production
      }
    }

    template {
      metadata {
        labels = {
          app         = var.app_name
          environment = var.namespace_production
        }
      }

      spec {
        node_selector = {
          environment = var.namespace_production
        }

        container {
          image = var.image
          name  = var.app_name
          port {
            container_port = 8080
          }

          # readiness_probe {
          #   http_get {
          #     path = "/WebGoat/health"
          #     port = 9090
          #   }
          #   initial_delay_seconds = 5
          #   timeout_seconds       = 1
          # }
        }
      }
    }
  }
}

# Services for development and production
resource "kubernetes_service" "development" {
  metadata {
    name      = var.namespace_development
    namespace = kubernetes_namespace.development.metadata[0].name
    labels = {
      app = var.app_name
    }
  }

  spec {
    selector = {
      app         = var.app_name
      environment = var.namespace_development
    }
    port {
      port        = 8080
      target_port = 8080
    }
    type = "NodePort"
  }
}

resource "kubernetes_service" "production" {
  metadata {
    name      = var.namespace_production
    namespace = kubernetes_namespace.production.metadata[0].name
    labels = {
      app = var.app_name
    }
  }

  spec {
    selector = {
      app         = var.app_name
      environment = var.namespace_production
    }
    port {
      port        = 8080
      target_port = 8080
    }
    type = "NodePort"
  }
}

# Ingress configuration for production
resource "kubernetes_ingress_v1" "ingress" {
  metadata {
    name      = "ingress"
    namespace = kubernetes_namespace.production.metadata[0].name
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
    }
  }

  spec {
    rule {
      http {
        path {
          path      = "/WebGoat"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.production.metadata[0].name
              port {
                number = 8080
              }
            }
          }
        }
      }
    }

    default_backend {
      service {
        name = kubernetes_service.production.metadata[0].name
        port {
          number = 8080
        }
      }
    }
  }
}
