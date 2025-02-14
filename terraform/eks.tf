resource "aws_eks_cluster" "eks_cluster" {
  name     = "hello-world-cluster"
  role_arn = aws_iam_role.eks_role.arn

# cluster should be in public subnet. Ideally it has to be in private subnet
  vpc_config {
    subnet_ids = [ for i in aws_subnet.public_subnets: i.id ] 
    /*
      Use endpoints to access the cluster nodes. Hence need to use 
      the below endpoints.
    */
    endpoint_private_access = "false" 
    endpoint_public_access  = "true" //In order to access the cluster from internet. Defaults to true.
    public_access_cidrs     = "0.0.0.0/0"    
  }
}

# resource "aws_eks_fargate_profile" "fargate_profile" {
#   cluster_name           = aws_eks_cluster.eks_cluster.name
#   fargate_profile_name   = "hello-world-fargate"
#   pod_execution_role_arn = aws_iam_role.fargate_pod_execution.arn
#   subnet_ids             = [ for i in aws_subnet.private_subnets: i.id ]
#   selector {
#     namespace = "hello-world"
#   }
# }
