# resource "aws_eks_cluster" "eks_cluster" {
#   name     = "hello-world-cluster"
#   role_arn = aws_iam_role.eks_role.arn

#   vpc_config {
#     subnet_ids = aws_subnet.private_subnets[*].id
#   }
# }

# resource "aws_eks_fargate_profile" "fargate_profile" {
#   cluster_name           = aws_eks_cluster.eks_cluster.name
#   fargate_profile_name   = "hello-world-fargate"
#   pod_execution_role_arn = aws_iam_role.fargate_pod_execution.arn
#   subnet_ids             = aws_subnet.private_subnets[*].id
#   selector {
#     namespace = "hello-world"
#   }
# }
