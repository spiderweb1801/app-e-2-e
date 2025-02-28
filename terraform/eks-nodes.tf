# resource "aws_launch_template" "eks_node_group" {
#   for_each = local.node_groups
#   name     = "${each.value}_template"

#   block_device_mappings {
#     device_name = "/dev/xvda"
#     ebs {
#       volume_size = 20
#       volume_type = "gp3"
#       iops        = 3000
#       throughput  = 125
#     }
#   }

#   image_id = var.eks_node_ami

#   metadata_options {
#     http_tokens                 = "required"
#     http_put_response_hop_limit = 2
#   }

#   network_interfaces {
#     security_groups = [
#       aws_security_group.eks_sg.id
#     ]
#   }

#   tag_specifications {
#     resource_type = "instance"
#     tags = {
#       Name                             = "${each.value}_node"
#       "alpha.eksctl.io/nodegroup-name" = each.value
#       "alpha.eksctl.io/nodegroup-type" = "managed"
#     }
#   }

#   tag_specifications {
#     resource_type = "volume"
#     tags = {
#       Name                             = "${each.value}_node"
#       "alpha.eksctl.io/nodegroup-name" = each.value
#       "alpha.eksctl.io/nodegroup-type" = "managed"
#     }
#   }

#   tag_specifications {
#     resource_type = "network-interface"
#     tags = {
#       Name                             = "${each.value}_node"
#       "alpha.eksctl.io/nodegroup-name" = each.value
#       "alpha.eksctl.io/nodegroup-type" = "managed"
#     }
#   }
# }

# resource "aws_eks_node_group" "eks_node" {
#   for_each        = local.node_groups
#   cluster_name    = aws_eks_cluster.eks_cluster.name
#   node_group_name = each.value
#   node_role_arn   = aws_iam_role.node_instance_role.arn
#   subnet_ids      = each.key == "private" ? [for i in aws_subnet.private_subnets : i.id] : [for i in aws_subnet.public_subnets : i.id] # Update with your VPC subnets
#   instance_types  = ["t3.medium"]
#   scaling_config {
#     desired_size = 1
#     max_size     = 2
#     min_size     = 1
#   }
#   update_config {
#     max_unavailable = 1
#   }
#   launch_template {
#     id      = aws_launch_template.eks_node_group[each.key].id
#     version = aws_launch_template.eks_node_group[each.key].latest_version
#   }
#   depends_on = [
#     aws_iam_role_policy_attachment.ebs_policy_attachment,
#     aws_iam_role_policy_attachment.efs_policy_attachment,
#     aws_iam_role_policy_attachment.efsec2_policy_attachment
#   ]
# }

# worked node security group

resource "aws_security_group" "eks_sg" {
  name        = "EKSSecurityGroup"
  description = "Communication between the control plane and worker nodegroups"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Open to all (change for security)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}