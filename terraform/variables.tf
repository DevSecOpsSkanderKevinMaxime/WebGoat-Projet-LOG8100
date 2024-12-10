variable "namespace" {
  description = "Nom du namespace"
  type        = string
  default     = "log8100projetns"
}

variable "replicas" {
  description = "Nombre de réplicas pour le déploiement"
  type        = number
  default     = 2
}
