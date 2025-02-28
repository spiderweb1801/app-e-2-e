#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status

echo "Updating system packages..."
yum update -y

echo "Installing kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x /usr/local/bin/kubectl
sudo chmod +x kubectl
sudo mv kubectl /usr/local/bin/
echo "Verifying kubectl installation..."
kubectl version --client || echo "kubectl installation failed."

echo "Installation complete."

echo "Configuring EKS access."
aws eks update-kubeconfig --name hello-world-cluster --region ap-south-1

echo "Installation complete."
