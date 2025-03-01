# Fetch Latest Amazon EKS-Optimized AMI for the selected Kubernetes version
data "aws_ssm_parameter" "eks_ami" {
  name = "/aws/service/eks/optimized-ami/1.27/amazon-linux-2/recommended/image_id"
}

# EKS Cluster
resource "aws_eks_cluster" "eks" {
  name     = "new-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids         = concat([for i in aws_subnet.public_subnets : i.id], [for i in aws_subnet.private_subnets : i.id])
    security_group_ids = [aws_security_group.eks_cluster_sg.id]
  }

  depends_on = [aws_iam_role_policy_attachment.eks_cluster_AmazonEKSClusterPolicy]
}