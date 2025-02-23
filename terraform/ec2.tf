## Still working on it

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
  key_name               = "for-bastion-putty" //"for-bastion" # aws_key_pair.generated_key.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  subnet_id              = aws_subnet.public_subnets["subnet1"].id
  iam_instance_profile   = "temp-ec2-eks"

  user_data = <<-EOF
    #!/bin/bash
    set -e  # Exit immediately if a command exits with a non-zero status

    echo "Updating system packages..."
    yum update -y

    echo "Installing kubectl..."
    curl -o /usr/local/bin/kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.29.0/2023-11-07/bin/linux/amd64/kubectl
    chmod +x /usr/local/bin/kubectl

    echo "Verifying kubectl installation..."
    kubectl version --client || echo "kubectl installation failed."

    echo "Installation complete."

    echo "Configuring EKS access."
    aws eks update-kubeconfig --name hello-world-cluster --region ap-south-1 --alias eks-cluster
  EOF

  tags = {
    Name = "Terraform-EC2-Bastion-Host"
  }
}
