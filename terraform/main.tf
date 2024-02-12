// main.tf

provider "kubernetes" {
  config_path = "~/.kube/config_kind"
}

resource "kubectl_manifest" "node_app" {
  yaml_body = file("${path.module}/deployment.yaml")
}
