
locals {
  vpc = {
    public_subnets = {
      subnet1 = {
        name              = "public-subnet-1"
        cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, 0)
        availability_zone = "${data.aws_region.current.name}a"
      },
      subnet2 = {
        name              = "public-subnet-2"
        cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, 1)
        availability_zone = "${data.aws_region.current.name}b"
      }
    },
    private_subnets = {
      subnet1 = {
        name              = "private-subnet-1"
        cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, 2)
        availability_zone = "${data.aws_region.current.name}a"
      },
      subnet2 = {
        name              = "private-subnet-2"
        cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, 3)
        availability_zone = "${data.aws_region.current.name}b"
      }
    }
  }

  node_groups = {
    "public"  = "public-eks-managed-nodes"
    "private" = "private-eks-managed-nodes"
  }
}

variable "ami" {
  type    = string
  default = "ami-001fa4fe00c43b5f6"
}

variable "eks_node_ami" {
  type    = string
  default = "ami-06c26bd3c5caf927f"
}