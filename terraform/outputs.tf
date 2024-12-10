output "service_url" {
  value = "http://192.168.49.2:${kubernetes_service.webgoat.spec[0].port[0].node_port}/WebGoat"
}
