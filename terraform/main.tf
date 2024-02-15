terraform {
  required_version = ">= 0.13"

  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

provider "kubectl" {
  load_config_file = true
  config_path      = "~/.kube/config_kind"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config_kind"
  }
}


data "kubectl_path_documents" "docs" {
    pattern = "./templates/*.yaml"
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
  values = [ file("${path.module}/templates/values/values.yaml") ]
}

resource "kubectl_manifest" "grafana-ingress" {
  yaml_body = <<YAML
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: grafana-ingress
  annotations:
    # nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
    # nginx.ingress.kubernetes.io/ssl-redirect: "true" # Redirect HTTP to HTTPS
    kubernetes.io/ingress.className: "nginx"
  namespace: monitoring
spec:
  ingressClassName: nginx
  rules:
    - host: grafana.hello-world.local
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: kube-prometheus-stack-grafana
                port:
                  number: 80

YAML
}
