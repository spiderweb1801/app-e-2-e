provider "aws" {
  region = "ap-south-1"

  default_tags {
    tags = {
      Project   = "LiveStreamingApp"
      Owner     = "SachinSagar"
      Environment = "Development"
      createdBy = "Terraform"
    }
  }
}