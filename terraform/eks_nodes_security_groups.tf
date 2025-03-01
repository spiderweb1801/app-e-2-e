resource "aws_security_group" "eks_nodes_sg" {
  name        = "EKSNodeSecurityGroup"
  description = "Allow managed and unmanaged nodes to communicate with each other (all ports)"
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