provider "aws" {
  region = "ap-south-1"

  default_tags {
    tags = {
      Project     = "LiveStreamingApp"
      Owner       = "SachinSagar"
      Environment = "Development"
      createdBy   = "Terraform"
    }
  }
}


# provider "kubernetes" {
#   host                   = aws_eks_cluster.live_streaming_cluster.endpoint
#   cluster_ca_certificate = base64decode(aws_eks_cluster.eks.certificate_authority[0].data)
#   token                  = data.aws_eks_cluster_auth.cluster.token
#   alias                  = "k8s"
# }


# provider "helm" {
#   kubernetes {
#     config_path = "~/.kube/config"
#   }
#   alias = "helm"
# }
