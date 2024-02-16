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


#  to: 'onyekachukwu@example.com'
#  from: 'alertmanager@example.com'
#  smarthost: 'sandbox.smtp.mailtrap.io:2525'
#  auth_username: 'd06592af1f74b7'
#  auth_password: '24a46ab73bc13a'
# KP7qbSnEeEGWk!X

variable "email_auth" {
  type = object({
    email_to   = string
    email_from = string
    email_host = string
    email_user = string
    email_pass = string
  })
  description = "Email authentication credentials for alert-manager"
  default = {
    email_to   = "null"
    email_from = "null"
    email_host = "null"
    email_user = "null"
    email_pass = "null"
  }
}
