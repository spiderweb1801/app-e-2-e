# EKS Cluster Provisioning with eksctl

## To provision the EKS cluster with custom NodeGroup configurations, use the "eks-cluster-manifest.yaml" manifestation file. 

## Overview
When you run the command:

```sh
eksctl create cluster -f eks-cluster-manifest.yaml
```

It triggers the creation of an Amazon EKS cluster resources using a CloudFormation template. This template provisions all the necessary resources, including:

# AWS CloudFormation Template for EKS Cluster

## Overview
This AWS CloudFormation template provisions an Amazon EKS (Elastic Kubernetes Service) cluster along with the necessary networking and IAM components. It sets up a dedicated VPC, subnets, security groups, and IAM roles required for managing the EKS cluster.

## Features
- **Amazon EKS Cluster**: Deploys an EKS cluster with version 1.28.
- **Dedicated VPC**: Creates a new Virtual Private Cloud (VPC) with private and public subnets.
- **Security Groups**: Defines security groups for cluster nodes and control plane communication.
- **IAM Roles**: Provisions IAM roles with necessary permissions for EKS.
- **Networking**:
  - Public and private subnets
  - Internet Gateway
  - NAT Gateway for private subnets
  - Route tables for network traffic control
- **Outputs**: Exports essential cluster details such as ARN, security groups, subnets, and IAM role ARNs.

## Resources Created
### VPC and Networking
- VPC with CIDR block `192.168.0.0/16`
- Public and private subnets across multiple availability zones
- Internet Gateway and NAT Gateway for external access
- Route tables and associations

### Security Groups
- **ClusterSharedNodeSecurityGroup**: Allows communication between all nodes in the cluster.
- **ControlPlaneSecurityGroup**: Manages communication between the control plane and worker nodes.
- Security group ingress rules for inter-node and control plane communication.

### EKS Cluster
- Deploys an EKS control plane named `my-eks-cluster`.
- Enables API authentication and public endpoint access.
- Associates the cluster with the provisioned IAM role and security groups.

### IAM Roles
- **ServiceRole**: IAM role for the EKS control plane with necessary policies (`AmazonEKSClusterPolicy`, `AmazonEKSVPCResourceController`).

## Outputs
- **ARN**: EKS Cluster ARN
- **Endpoint**: API server endpoint for cluster communication
- **CertificateAuthorityData**: Data for Kubernetes authentication
- **SubnetsPublic**: List of public subnet IDs
- **SubnetsPrivate**: List of private subnet IDs
- **ClusterSecurityGroupId**: Security group ID for the cluster
- **ServiceRoleARN**: ARN of the IAM role for EKS

## Usage
### Deploying the CloudFormation Stack
1. Upload the template file to AWS CloudFormation.
2. Create a new stack and provide necessary parameters.
3. Wait for stack creation to complete.
4. Retrieve outputs for connecting to the EKS cluster.

### Connecting to the EKS Cluster
Once the stack is deployed, configure `kubectl` to interact with the cluster:
```sh
aws eks update-kubeconfig --region <your-region> --name my-eks-cluster
kubectl get nodes
```

## Prerequisites
- AWS CLI installed and configured
- kubectl installed for Kubernetes management
- AWS IAM permissions to create CloudFormation stacks and EKS resources

## Cleanup
To delete the EKS cluster and associated resources, run:
```sh
aws cloudformation delete-stack --stack-name <your-stack-name>
```

## License
This project is licensed under the MIT License.

