# resource "aws_iam_role" "eks_node_role" {
#   name = "eks-node-group-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Action = "sts:AssumeRole"
#       Effect = "Allow"
#       Principal = {
#         Service = "ec2.amazonaws.com"
#       }
#     }]
#   })
# }

# # This policy allows Amazon EKS worker nodes to connect to Amazon EKS Clusters.
# resource "aws_iam_role_policy_attachment" "eks_worker_node" {
#   role       = aws_iam_role.eks_node_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
# }

# /*
# This policy provides the Amazon VPC CNI Plugin (amazon-vpc-cni-k8s) the permissions 
# it requires to modify the IP address configuration on your EKS worker nodes. 
# This permission set allows the CNI to list, describe, and modify Elastic Network 
# Interfaces on your behalf. More information on the AWS VPC CNI Plugin is available here: 
# https://github.com/aws/amazon-vpc-cni-k8s
# */
# resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
#   role       = aws_iam_role.eks_node_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
# }

# # Provides read-only access to Amazon EC2 Container Registry repositories.
# resource "aws_iam_role_policy_attachment" "eks_container_registry" {
#   role       = aws_iam_role.eks_node_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
# }


resource "aws_iam_role" "eks_node_role1" {
  name = "eks-node-group-role1"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      "Action" : [
        "sts:AssumeRoleWithWebIdentity"
      ],
      "Condition" : {
        "StringEquals" : {
          "oidc.eks.us-east-1.amazonaws.com/id/6C6C5339FAFB5CA340A5D110601225D4:aud" : "sts.amazonaws.com",
          "oidc.eks.us-east-1.amazonaws.com/id/6C6C5339FAFB5CA340A5D110601225D4:sub" : "system:serviceaccount:default:ecr-access-sa"
        }
      },
      "Effect" : "Allow",
      "Principal" : {
        "Federated" : "arn:aws:iam::183631319967:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/6C6C5339FAFB5CA340A5D110601225D4"
      }
    }]
  })
}

# Provides read-only access to Amazon EC2 Container Registry repositories.
resource "aws_iam_role_policy_attachment" "eks_container_registry_role1" {
  role       = aws_iam_role.eks_node_role1.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# Provides read-only access to Amazon EC2 Container Registry repositories.
resource "aws_iam_role_policy_attachment" "eks_container_registry_role2" {
  role       = aws_iam_role.eks_node_role1.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role" "node_instance_role" {
  name = "my-node-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = [
            "ec2.amazonaws.com"
          ]
        }
      }
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]

  path = "/"

  tags = {
    Name = "my-node-instance-role"
  }
}


resource "aws_iam_policy" "ebs_policy" {
  name        = "node-group-PolicyEBS"
  path        = "/"
  description = "IAM policy for EBS CSI Driver"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:CreateSnapshot",
          "ec2:AttachVolume",
          "ec2:DetachVolume",
          "ec2:ModifyVolume",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeInstances",
          "ec2:DescribeSnapshots",
          "ec2:DescribeTags",
          "ec2:DescribeVolumes",
          "ec2:DescribeVolumesModifications"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = ["ec2:CreateTags"]
        Condition = {
          StringEquals = {
            "ec2:CreateAction" = ["CreateVolume", "CreateSnapshot"]
          }
        }
        Resource = [
          "arn:aws:ec2:*:*:volume/*",
          "arn:aws:ec2:*:*:snapshot/*"
        ]
      },
      {
        Effect = "Allow"
        Action = ["ec2:DeleteTags"]
        Resource = [
          "arn:aws:ec2:*:*:volume/*",
          "arn:aws:ec2:*:*:snapshot/*"
        ]
      },
      {
        Effect = "Allow"
        Action = ["ec2:CreateVolume"]
        Condition = {
          StringLike = {
            "aws:RequestTag/ebs.csi.aws.com/cluster" = "true"
          }
        }
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = ["ec2:CreateVolume"]
        Condition = {
          StringLike = {
            "aws:RequestTag/CSIVolumeName" = "*"
          }
        }
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = ["ec2:DeleteVolume"]
        Condition = {
          StringLike = {
            "ec2:ResourceTag/ebs.csi.aws.com/cluster" = "true"
          }
        }
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = ["ec2:DeleteVolume"]
        Condition = {
          StringLike = {
            "ec2:ResourceTag/CSIVolumeName" = "*"
          }
        }
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = ["ec2:DeleteVolume"]
        Condition = {
          StringLike = {
            "ec2:ResourceTag/kubernetes.io/created-for/pvc/name" = "*"
          }
        }
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = ["ec2:DeleteSnapshot"]
        Condition = {
          StringLike = {
            "ec2:ResourceTag/CSIVolumeSnapshotName" = "*"
          }
        }
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = ["ec2:DeleteSnapshot"]
        Condition = {
          StringLike = {
            "ec2:ResourceTag/ebs.csi.aws.com/cluster" = "true"
          }
        }
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ebs_policy_attachment" {
  role       = aws_iam_role.node_instance_role.name
  policy_arn = aws_iam_policy.ebs_policy.arn
}

resource "aws_iam_policy" "efs_policy" {
  name        = "node-group-PolicyEFS"
  description = "Policy to allow full access to Amazon EFS"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["elasticfilesystem:*"]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "efs_policy_attachment" {
  policy_arn = aws_iam_policy.efs_policy.arn
  role       = aws_iam_role.node_instance_role.name
}

resource "aws_iam_policy" "efsec2_policy" {
  name        = "node-group-PolicyEFSEC2"
  description = "Policy to allow EC2 network interface and subnet operations for EFS"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeSubnets",
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface",
          "ec2:ModifyNetworkInterfaceAttribute",
          "ec2:DescribeNetworkInterfaceAttribute"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "efsec2_policy_attachment" {
  policy_arn = aws_iam_policy.efsec2_policy.arn
  role       = aws_iam_role.node_instance_role.name
}

resource "aws_iam_policy" "ALBController_policy" {
  name        = "node-group-PolicyALBController"
  description = "ALB Controller role"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Condition": {
                "StringEquals": {
                    "iam:AWSServiceName": "elasticloadbalancing.amazonaws.com"
                }
            },
            "Action": [
                "iam:CreateServiceLinkedRole"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "ec2:DescribeAccountAttributes",
                "ec2:DescribeAddresses",
                "ec2:DescribeAvailabilityZones",
                "ec2:DescribeInternetGateways",
                "ec2:DescribeVpcs",
                "ec2:DescribeVpcPeeringConnections",
                "ec2:DescribeSubnets",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeInstances",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DescribeTags",
                "ec2:GetCoipPoolUsage",
                "ec2:DescribeCoipPools",
                "elasticloadbalancing:DescribeLoadBalancers",
                "elasticloadbalancing:DescribeLoadBalancerAttributes",
                "elasticloadbalancing:DescribeListeners",
                "elasticloadbalancing:DescribeListenerAttributes",
                "elasticloadbalancing:DescribeListenerCertificates",
                "elasticloadbalancing:DescribeSSLPolicies",
                "elasticloadbalancing:DescribeRules",
                "elasticloadbalancing:DescribeTargetGroups",
                "elasticloadbalancing:DescribeTargetGroupAttributes",
                "elasticloadbalancing:DescribeTargetHealth",
                "elasticloadbalancing:DescribeTags"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "cognito-idp:DescribeUserPoolClient",
                "acm:ListCertificates",
                "acm:DescribeCertificate",
                "iam:ListServerCertificates",
                "iam:GetServerCertificate",
                "waf-regional:GetWebACL",
                "waf-regional:GetWebACLForResource",
                "waf-regional:AssociateWebACL",
                "waf-regional:DisassociateWebACL",
                "wafv2:GetWebACL",
                "wafv2:GetWebACLForResource",
                "wafv2:AssociateWebACL",
                "wafv2:DisassociateWebACL",
                "shield:GetSubscriptionState",
                "shield:DescribeProtection",
                "shield:CreateProtection",
                "shield:DeleteProtection"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:RevokeSecurityGroupIngress"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "ec2:CreateSecurityGroup"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Condition": {
                "StringEquals": {
                    "ec2:CreateAction": "CreateSecurityGroup"
                },
                "Null": {
                    "aws:RequestTag/elbv2.k8s.aws/cluster": "false"
                }
            },
            "Action": [
                "ec2:CreateTags"
            ],
            "Resource": "arn:aws:ec2:*:*:security-group/*",
            "Effect": "Allow"
        },
        {
            "Condition": {
                "Null": {
                    "aws:RequestTag/elbv2.k8s.aws/cluster": "true",
                    "aws:ResourceTag/elbv2.k8s.aws/cluster": "false"
                }
            },
            "Action": [
                "ec2:CreateTags",
                "ec2:DeleteTags"
            ],
            "Resource": "arn:aws:ec2:*:*:security-group/*",
            "Effect": "Allow"
        },
        {
            "Condition": {
                "Null": {
                    "aws:ResourceTag/elbv2.k8s.aws/cluster": "false"
                }
            },
            "Action": [
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:RevokeSecurityGroupIngress",
                "ec2:DeleteSecurityGroup"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Condition": {
                "Null": {
                    "aws:RequestTag/elbv2.k8s.aws/cluster": "false"
                }
            },
            "Action": [
                "elasticloadbalancing:CreateLoadBalancer",
                "elasticloadbalancing:CreateTargetGroup"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "elasticloadbalancing:CreateListener",
                "elasticloadbalancing:DeleteListener",
                "elasticloadbalancing:CreateRule",
                "elasticloadbalancing:DeleteRule"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Condition": {
                "Null": {
                    "aws:RequestTag/elbv2.k8s.aws/cluster": "true",
                    "aws:ResourceTag/elbv2.k8s.aws/cluster": "false"
                }
            },
            "Action": [
                "elasticloadbalancing:AddTags",
                "elasticloadbalancing:RemoveTags"
            ],
            "Resource": [
                "arn:aws:elasticloadbalancing:*:*:targetgroup/*/*",
                "arn:aws:elasticloadbalancing:*:*:loadbalancer/net/*/*",
                "arn:aws:elasticloadbalancing:*:*:loadbalancer/app/*/*"
            ],
            "Effect": "Allow"
        },
        {
            "Action": [
                "elasticloadbalancing:AddTags",
                "elasticloadbalancing:RemoveTags"
            ],
            "Resource": [
                "arn:aws:elasticloadbalancing:*:*:listener/net/*/*/*",
                "arn:aws:elasticloadbalancing:*:*:listener/app/*/*/*",
                "arn:aws:elasticloadbalancing:*:*:listener-rule/net/*/*/*",
                "arn:aws:elasticloadbalancing:*:*:listener-rule/app/*/*/*"
            ],
            "Effect": "Allow"
        },
        {
            "Condition": {
                "Null": {
                    "aws:ResourceTag/elbv2.k8s.aws/cluster": "false"
                }
            },
            "Action": [
                "elasticloadbalancing:ModifyListenerAttributes",
                "elasticloadbalancing:ModifyLoadBalancerAttributes",
                "elasticloadbalancing:SetIpAddressType",
                "elasticloadbalancing:SetSecurityGroups",
                "elasticloadbalancing:SetSubnets",
                "elasticloadbalancing:DeleteLoadBalancer",
                "elasticloadbalancing:ModifyTargetGroup",
                "elasticloadbalancing:ModifyTargetGroupAttributes",
                "elasticloadbalancing:DeleteTargetGroup"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Condition": {
                "StringEquals": {
                    "elasticloadbalancing:CreateAction": [
                        "CreateTargetGroup",
                        "CreateLoadBalancer"
                    ]
                },
                "Null": {
                    "aws:RequestTag/elbv2.k8s.aws/cluster": "false"
                }
            },
            "Action": [
                "elasticloadbalancing:AddTags"
            ],
            "Resource": [
                "arn:aws:elasticloadbalancing:*:*:targetgroup/*/*",
                "arn:aws:elasticloadbalancing:*:*:loadbalancer/net/*/*",
                "arn:aws:elasticloadbalancing:*:*:loadbalancer/app/*/*"
            ],
            "Effect": "Allow"
        },
        {
            "Action": [
                "elasticloadbalancing:RegisterTargets",
                "elasticloadbalancing:DeregisterTargets"
            ],
            "Resource": "arn:aws:elasticloadbalancing:*:*:targetgroup/*/*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "elasticloadbalancing:SetWebAcl",
                "elasticloadbalancing:ModifyListener",
                "elasticloadbalancing:AddListenerCertificates",
                "elasticloadbalancing:RemoveListenerCertificates",
                "elasticloadbalancing:ModifyRule"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
})
}

resource "aws_iam_role_policy_attachment" "albcontroller_policy_attachment" {
  policy_arn = aws_iam_policy.ALBController_policy.arn
  role       = aws_iam_role.node_instance_role.name
}
