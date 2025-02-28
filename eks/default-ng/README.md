# EKS Cluster Provisioning with eksctl

## Create basic eks manifestation file
```
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig

metadata:
  name: web-quickstart
  region: <region-code>

autoModeConfig:
  enabled: true
```

## Overview
When you run the command:

```sh
eksctl create cluster -f eks-cluster-manifest.yaml
```

It triggers the creation of an Amazon EKS cluster using a CloudFormation template. This template provisions all the necessary resources, including:

- **Amazon EKS Control Plane**: Manages the Kubernetes cluster.
- **Amazon EC2 Instances (Worker Nodes)**: If not using Fargate, worker nodes are created.
- **IAM Roles and Policies**: Grants necessary permissions to the cluster and nodes.
- **Amazon VPC and Networking Components**: Subnets, route tables, security groups, etc.
- **AWS Auto Scaling Groups**: Manages worker node scaling.
- **Amazon EBS Storage (Optional)**: Persistent storage for workloads.

## CloudFormation Template
eksctl internally generates a CloudFormation template, which includes multiple stacks for different components of the cluster:

1. **Cluster Stack** - Provisions the EKS control plane.
2. **Node Group Stack** - Creates worker nodes using EC2 instances.
3. **VPC Stack** - Sets up networking infrastructure (unless an existing VPC is specified).
4. **IAM Stack** - Defines roles and policies for EKS and nodes.

## The manifestation file at the backend created all the EKS resources using the cloudformation template. The template is "cloudformationtemplate.yaml" file.