// main.tf

terraform {
  required_version = ">= 0.13"

  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config_kind"
}

resource "kubectl_manifest" "node_app" {
  yaml_body = file("${path.module}/deployment.yaml")
}
