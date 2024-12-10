resource "kubernetes_namespace" "webgoat" {
  metadata {
    name = "log8100projetns"
  }
}

resource "kubernetes_deployment" "webgoat" {
  metadata {
    name      = "webgoat-deployment"
    namespace = kubernetes_namespace.webgoat.metadata[0].name
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = "webgoat"
      }
    }

    template {
      metadata {
        labels = {
          app = "webgoat"
        }
      }

      spec {
        container {
          image = "log8100projet/projetfinal:latest"
          name  = "webgoat-container"

          port {
            container_port = 8080
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "webgoat" {
  metadata {
    name      = "webgoat-service"
    namespace = kubernetes_namespace.webgoat.metadata[0].name
  }

  spec {
    selector = {
      app = kubernetes_deployment.webgoat.spec[0].template[0].metadata[0].labels["app"]
    }

    port {
      port        = 8080
      target_port = 8080
    }

    type = "NodePort"
  }
}
