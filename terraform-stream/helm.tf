# data "aws_eks_cluster_auth" "cluster" {
#   name = aws_eks_cluster.live_streaming_cluster.name
# }

# resource "helm_release" "nginx_ingress" {
#   name       = "nginx-ingress"
#   repository = "https://kubernetes.github.io/ingress-nginx"
#   chart      = "ingress-nginx"
#   namespace  = "nginx"

#   create_namespace = true

#   set {
#     name  = "controller.kind"
#     value = "DaemonSet"
#   }

#   set {
#     name  = "controller.service.type"
#     value = "LoadBalancer"
#   }
# }

# resource "helm_release" "mock_streaming_app" {
#   name             = "mock-streaming-app"
#   chart            = "./charts/mock-backend"   # A mock Helm chart we can create
#   namespace        = "live-stream"
#   create_namespace = true

#   set {
#     name  = "image.repository"
#     value = "nginxdemos/hello"
#   }

#   set {
#     name  = "image.tag"
#     value = "latest"
#   }

#   set {
#     name  = "service.type"
#     value = "LoadBalancer"
#   }

#   set {
#     name  = "replicaCount"
#     value = "2"
#   }
# }
