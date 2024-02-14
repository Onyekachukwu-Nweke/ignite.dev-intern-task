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

resource "kubectl_manifest" "node_app" {
  yaml_body = <<YAML
# apiVersion: apps/v1
# kind: Deployment
# metadata:
#   name: hello-world
# spec:
#   replicas: 1
#   selector:
#     matchLabels:
#       app: hello-world
#   template:
#     metadata:
#       labels:
#         app: hello-world
#     spec:
#       containers:
#         - name: hello-world
#           image: onyekachukwu/node-hello-world
#           ports:
#             - containerPort: 3000
#           resources:
#             limits:
#               cpu: "0.5"
#               memory: "512Mi"
#             requests:
#               cpu: "0.25"
#               memory: "256Mi"
#           livenessProbe:
#             httpGet:
#               path: /
#               port: 3000
#             initialDelaySeconds: 15
#             periodSeconds: 10
#           readinessProbe:
#             httpGet:
#               path: /
#               port: 3000
#             initialDelaySeconds: 5
#             periodSeconds: 5
---
apiVersion: v1
kind: Service
metadata:
  name: hello-world-service
spec:
  selector:
    app: hello-world
  ports:
    - protocol: TCP
      port: 80
      targetPort: 3000
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: hello-world-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /$2
    nginx.ingress.kubernetes.io/use-regex: "true"
    kubernetes.io/ingress.className: "nginx"
spec:
  ingressClassName: nginx
  rules:
    - http:
        paths:
          - path: /(.*)
            pathType: ImplementationSpecific
            backend:
              service:
                name: hello-world-service
                port:
                  number: 80
YAML
}
