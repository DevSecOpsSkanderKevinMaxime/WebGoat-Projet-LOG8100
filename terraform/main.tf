# defining here the namespaces used on kube
resource "kubernetes_namespace" "development" {
  metadata {
    name = "development"
  }
}

resource "kubernetes_namespace" "production" {
  metadata {
    name = "production"
  }
}

# setting the deployment strategy for each node

resource "kubernetes_deployment" "development" {
  metadata {
    name      = "development"
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
          environment = "development" # Runs on nodes labeled with "environment=development"
        }

        container {
          image = "log8100projet/projetfinal:latest"
          name  = "webgoat"
          port {
            container_port = 8080
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "production" {
  metadata {
    name      = "production"
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
          environment = "production"
        }

        container {
          image = "log8100projet/projetfinal:latest"
          name  = "webgoat"
          port {
            container_port = 8080
          }
        }
      }
    }
  }
}

# setting up services which act as proxies to access the internal cluster nodes

resource "kubernetes_service" "development" {
  metadata {
    name      = "development"
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

resource "kubernetes_service" "production" {
  metadata {
    name      = "production"
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

resource "kubernetes_service" "devhealth" {
  metadata {
    name      = "devhealth"
    namespace = kubernetes_namespace.development.metadata[0].name
  }

  spec {
    selector = { test = "webgoat" }
    port {
      port        = 9090
      target_port = 9090

    }
    type = "NodePort"
  }
}

resource "kubernetes_service" "prodhealth" {
  metadata {
    name      = "prodhealth"
    namespace = kubernetes_namespace.production.metadata[0].name
  }

  spec {
    selector = { test = "webgoat" }
    port {
      port        = 9090
      target_port = 9090
    }
    type = "NodePort"
  }
}

resource "kubernetes_ingress_v1" "requests" {
  metadata {
    name      = "requests"
    namespace = kubernetes_namespace.production.metadata[0].name
  }

  spec {
    rule {
      http {
        path {
          path      = "/nope/*"
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
        name = kubernetes_service.prodhealth.metadata[0].name
        port {
          number = 9090
        }
      }
    }
  }
}



