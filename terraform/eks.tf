# resource "aws_eks_cluster" "eks_cluster" {
#   name     = "hello-world-cluster"
#   role_arn = aws_iam_role.eks_role.arn

#   # cluster should be in public subnet. Ideally it has to be in private subnet
#   vpc_config {
#     subnet_ids              = concat([for i in aws_subnet.public_subnets : i.id], [for i in aws_subnet.private_subnets : i.id])
#     endpoint_private_access = "false"
#     endpoint_public_access  = "true" //In order to access the cluster from internet. Defaults to true.
#     public_access_cidrs     = ["0.0.0.0/0"]
#   }
# }
