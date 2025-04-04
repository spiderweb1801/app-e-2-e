resource "aws_eks_cluster" "live_streaming_cluster" {
  name     = "live-streaming-cluster"
  role_arn = aws_iam_role.eks_fargate_role.arn

  vpc_config {
    subnet_ids = concat([for i in aws_subnet.public_subnets : i.id], [for i in aws_subnet.private_subnets : i.id])
  }

  tags = {
    Name = "live-streaming-cluster"
  }
}

resource "aws_eks_fargate_profile" "fargate_profile" {
  cluster_name           = aws_eks_cluster.live_streaming_cluster.name
  fargate_profile_name   = "fargate-profile"
  pod_execution_role_arn = aws_iam_role.fargate_pod_execution_role.arn

  subnet_ids = [for i in aws_subnet.private_subnets : i.id]

  selector {
    namespace = "default"
  }
}

# resource "kubernetes_namespace" "live_streaming" {
#   metadata {
#     name = "live-streaming"
#   }
# }
