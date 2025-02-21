# terraform {
#   backend "remote" {
#     organization = "Master_spider"

#     workspaces {
#       name = "app-e-2-e"
#     }
#   }
# }

terraform {
  backend "s3" { # Change to your preferred AWS region
    encrypt = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
