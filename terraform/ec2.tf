# Generate SSH Key Pair
resource "tls_private_key" "bastion_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "generated_key" {
  key_name   = "my-terraform-key"
  public_key = tls_private_key.bastion_key.public_key_openssh
}

# Save Private Key Locally
resource "local_file" "private_key" {
  filename        = "my-terraform-key.pem"
  content         = tls_private_key.bastion_key.private_key_pem
  file_permission = "0600"
}

# Security Group for EC2
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-ssh-access"
  description = "Allow SSH access"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Open to all (change for security)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create t3.medium EC2 Instance
resource "aws_instance" "bastion" {
  ami                    = var.ami
  instance_type          = "t3.medium"
  key_name               = aws_key_pair.generated_key.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.name]
  subnet_id              = aws_subnet.public_subnets["subnet1"].id
  iam_instance_profile   = "temp-ec2-eks"

  tags = {
    Name = "Terraform-EC2-Bastion-Host"
  }
}
