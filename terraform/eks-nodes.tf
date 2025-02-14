resource "aws_eks_node_group" "eks_nodes_private" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "private-eks-managed-nodes"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = [ for i in aws_subnet.private_subnets: i.id ] # Update with your VPC subnets
  instance_types  = ["t3.medium"]
  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }
  update_config {
    max_unavailable = 1
  }
  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.eks_container_registry,
  ]
}

resource "aws_eks_node_group" "eks_nodes_public" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "public-eks-managed-nodes"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = [ for i in aws_subnet.public_subnets: i.id ] # Update with your VPC subnets
  instance_types  = ["t3.medium"]
  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }
  update_config {
    max_unavailable = 1
  }
  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.eks_container_registry,
  ]
}
