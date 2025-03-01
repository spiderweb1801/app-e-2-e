# data "aws_ssm_parameter" "eks_ami" {
#   name = "/aws/service/eks/optimized-ami/1.27/amazon-linux-2/recommended/image_id"
# }

# resource "aws_launch_template" "eks_node_group" {
#   name     = "eks_template"

#   block_device_mappings {
#     device_name = "/dev/xvda"
#     ebs {
#       volume_size = 20
#       volume_type = "gp3"
#       iops        = 3000
#       throughput  = 125
#     }
#   }

#   image_id = data.aws_ssm_parameter.eks_ami.value

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
#       Name                             = "eks_node"
#       "alpha.eksctl.io/nodegroup-type" = "managed"
#     }
#   }

#   tag_specifications {
#     resource_type = "volume"
#     tags = {
#       Name                             = "eks_node"
#       "alpha.eksctl.io/nodegroup-type" = "managed"
#     }
#   }

#   tag_specifications {
#     resource_type = "network-interface"
#     tags = {
#       Name                             = "eks_node"
#       "alpha.eksctl.io/nodegroup-type" = "managed"
#     }
#   }

# }

# resource "aws_eks_node_group" "eks_node" {
#   for_each        = local.node_groups
#   cluster_name    = aws_eks_cluster.eks_cluster.name
#   node_group_name = "${each.value}-ng"
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
#     id      = aws_launch_template.eks_node_group.id
#     version = "$Latest"
#   }
#   depends_on = [
#     aws_iam_role_policy_attachment.ebs_policy_attachment,
#     aws_iam_role_policy_attachment.efs_policy_attachment,
#     aws_iam_role_policy_attachment.efsec2_policy_attachment,
#     aws_iam_role_policy_attachment.albcontroller_policy_attachment
#   ]
# }

