# resource "aws_security_group" "eks_sg" {
#   name        = "EKSSecurityGroup"
#   description = "Communication between the control plane and worker nodegroups"
#   vpc_id      = aws_vpc.main.id

#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }