terraform {
  required_version = ">= 0.13"

  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }

    helm = {
      source = "hashicorp/helm"
      version = ">= 2.10.0"
    }

    kubernetes = {
      source = "hashicorp/kubernetes"
      version = ">= 2.30.0"
    }
  }
}

provider "kubectl" {
  load_config_file = true
  config_path      = pathexpand(var.cluster_config_path)
}

provider "helm" {
  kubernetes {
    config_path = pathexpand(var.cluster_config_path)
  }
}

provider "kubernetes" {
  config_path = pathexpand(var.cluster_config_path)
}