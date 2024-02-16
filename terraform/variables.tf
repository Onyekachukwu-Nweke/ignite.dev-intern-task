variable "cluster_config_path" {
  type        = string
  description = "Cluster's kubeconfig location"
  default     = "~/.kube/config"
}

variable "domain" {
  type = string
  description = "domain of the application"
  default = "hello-world.local"
}

variable "grafana_domain" {
  type = string
  description = "domain of the application"
  default = "grafana.hello-world.local"
}

variable "prometheus_domain" {
  type = string
  description = "domain of the prometheus monitoring"
  default = "prometheus.hello-world.local"
}

# variable "email_auth" {
#   type = object({
#     email_to   = string
#     email_from = string
#     email_host = string
#     email_user = string
#     email_pass = string
#   })
#   description = "Email authentication credentials for alert-manager"
#   default = {
#     email_to   = "null"
#     email_from = "null"
#     email_host = "null"
#     email_user = "null"
#     email_pass = "null"
#   }
# }
