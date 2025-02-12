
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
        cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, 0)
        availability_zone = "${data.aws_region.current.name}a"
      },
      subnet2 = {
        name              = "private-subnet-2"
        cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, 1)
        availability_zone = "${data.aws_region.current.name}b"
      }
    }
  }
}