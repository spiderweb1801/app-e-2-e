data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.live_streaming_cluster.name
}

resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = "nginx"

  create_namespace = true

  set {
    name  = "controller.kind"
    value = "DaemonSet"
  }

  set {
    name  = "controller.service.type"
    value = "LoadBalancer"
  }
}
