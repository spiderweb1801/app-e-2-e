# Launch Template for EKS Nodes
resource "aws_launch_template" "eks_nodes" {
  name_prefix   = "eks-node-template"
  image_id      = data.aws_ssm_parameter.eks_ami.value
  instance_type = "t3.medium"

  network_interfaces {
    security_groups = [aws_security_group.eks_node_sg.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "eks-node"
    }
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    set -o xtrace
    /etc/eks/bootstrap.sh new-cluster
  EOF
  )
}

# First Node Group Using Launch Template
resource "aws_eks_node_group" "node_group_1" {
  cluster_name    = aws_eks_cluster.eks.name
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = [for i in aws_subnet.private_subnets : i.id]
  node_group_name = "node-group-1"

  launch_template {
    id      = aws_launch_template.eks_nodes.id
    version = "$Latest"
  }

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }
}

# Second Node Group Using Launch Template
resource "aws_eks_node_group" "node_group_2" {
  cluster_name    = aws_eks_cluster.eks.name
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = [for i in aws_subnet.public_subnets : i.id] 
  node_group_name = "node-group-2"

  launch_template {
    id      = aws_launch_template.eks_nodes.id
    version = "$Latest"
  }

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }
}
