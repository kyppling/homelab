provider "kubernetes" {
  config_path            = "/Users/pedromantecon/.kube/config"
  config_context         = "minikube"
  config_context_auth_info = "minikube"
  config_context_cluster   = "minikube"
}

provider "helm" {
  kubernetes {
    config_path    = "/Users/pedromantecon/.kube/config"
    config_context = "minikube"
  }
}

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argocd" {

  name       = "argocd"
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  chart      = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  version    = "7.7.12"

  create_namespace = true

  set {
    name  = "server.service.type"
    value = "NodePort"
  }

  set {
    name  = "server.service.nodePort"
    value = "30007"
  }
}

output "argocd_url" {
  value = "http://$(minikube ip):30007"
}
