data "kubectl_path_documents" "docs" {
    pattern = "./kubernetes/*.yaml"
}

resource "kubectl_manifest" "test" {
    for_each  = toset(data.kubectl_path_documents.docs.documents)
    yaml_body = each.value
}

resource "helm_release" "kube_prometheus_stack" {
  name       = "kube-prometheus-stack"
  create_namespace = true
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = "monitoring"
  values = [ file("${path.module}/templates/values.yaml") ]
}