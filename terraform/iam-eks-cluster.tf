resource "aws_iam_role" "eks_role" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Principal": {
				"Federated": "arn:aws:iam::183631319967:oidc-provider/oidc.eks.ap-south-1.amazonaws.com/id/78B46CF52904510D97250CC78B291942"
			},
			"Action": "sts:AssumeRoleWithWebIdentity",
			"Condition": {
				"StringEquals": {
					"oidc.eks.ap-south-1.amazonaws.com/id/78B46CF52904510D97250CC78B291942:aud": "sts.amazonaws.com",
					"oidc.eks.ap-south-1.amazonaws.com/id/78B46CF52904510D97250CC78B291942:sub": "system:serviceaccount:default:ecr-access-sa"
				}
			}
		}
	]
})
}

/*
This policy provides Kubernetes the permissions it requires to manage resources on your 
behalf. Kubernetes requires Ec2:CreateTags permissions to place identifying information 
on EC2 resources including but not limited to Instances, Security Groups, and Elastic 
Network Interfaces.
*/

resource "aws_iam_policy_attachment" "eks_cluster_policy" {
  name       = "eks-cluster-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  roles      = [aws_iam_role.eks_role.name]
}

# Policy used by VPC Resource Controller to manage ENI and IPs for worker nodes.
resource "aws_iam_policy_attachment" "eks_cluster_policy_2" {
  name       = "eks-cluster-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  roles      = [aws_iam_role.eks_role.name]
}


# Policy used Provides read-only access to Amazon EC2 Container Registry repositories..
resource "aws_iam_policy_attachment" "eks_cluster_policy_3" {
  name       = "eks-cluster-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  roles      = [aws_iam_role.eks_role.name]
}

resource "aws_iam_policy_attachment" "eks_cluster_policy_4" {
  name       = "eks-cluster-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  roles      = [aws_iam_role.eks_role.name]
}