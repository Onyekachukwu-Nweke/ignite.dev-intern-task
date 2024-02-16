variable "cluster_config_path" {
  type        = string
  description = "Cluster's kubeconfig location"
  default     = "~/.kube/config"
}

variable "domain" {
  type = string
  description = "domain of the application"
  default = ""
}

# variable "prom-domain" {
#   type        = string
#   description = "sub-domain name for prometheus monitoring"
#   default     = ""
# }

# variable "graf-domain" {
#   type        = string
#   description = "sub-domain name for grafana dashboard visualization"
#   default     = ""
# }

#  to: 'onyekachukwu@example.com'
#  from: 'alertmanager@example.com'
#  smarthost: 'sandbox.smtp.mailtrap.io:2525'
#  auth_username: 'd06592af1f74b7'
#  auth_password: '24a46ab73bc13a'

variable "email_auth" {
  type = object({
    email_to   = string
    email_from = string
    email_user = string
    email_pass = string
  })
  description = "Email authentication credentials for alert-manager"
  default = {
    email_to   = ""
    email_from = ""
    email_user = ""
    email_pass = ""
  }
}
