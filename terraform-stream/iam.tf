# EKS Fargate Role
resource "aws_iam_role" "eks_fargate_role" {
  name = "eks-fargate-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "eks-fargate.amazonaws.com"
        }
        Effect    = "Allow"
        Sid       = ""
      },
    ]
  })

  tags = {
    Name = "eks-fargate-role"
  }
}

resource "aws_iam_role_policy_attachment" "eks_fargate_policy" {
  role       = aws_iam_role.eks_fargate_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
}

# EC2 Role (if needed for instances or NAT Gateway)
resource "aws_iam_role" "ec2_role" {
  name = "ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect    = "Allow"
        Sid       = ""
      },
    ]
  })

  tags = {
    Name = "ec2-role"
  }
}

resource "aws_iam_role_policy_attachment" "ec2_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2RoleforSSM"
}

# S3 Access Role (for video storage)
resource "aws_iam_role" "s3_access_role" {
  name = "s3-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Effect    = "Allow"
        Sid       = ""
      },
    ]
  })

  tags = {
    Name = "s3-access-role"
  }
}

resource "aws_iam_role_policy_attachment" "s3_access_policy" {
  role       = aws_iam_role.s3_access_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# CloudFront Role (for CDN)
resource "aws_iam_role" "cloudfront_role" {
  name = "cloudfront-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Effect    = "Allow"
        Sid       = ""
      },
    ]
  })

  tags = {
    Name = "cloudfront-role"
  }
}

resource "aws_iam_role_policy_attachment" "cloudfront_policy" {
  role       = aws_iam_role.cloudfront_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCloudFrontReadOnlyAccess"
}

# Billing & Cost Management Role
resource "aws_iam_role" "billing_role" {
  name = "billing-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "awsbilling.amazonaws.com"
        }
        Effect    = "Allow"
        Sid       = ""
      },
    ]
  })

  tags = {
    Name = "billing-role"
  }
}

resource "aws_iam_role_policy_attachment" "billing_policy" {
  role       = aws_iam_role.billing_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSBillingReadOnlyAccess"
}

# CloudWatch & CloudTrail Role (Logging)
resource "aws_iam_role" "cloudwatch_role" {
  name = "cloudwatch-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "cloudwatch.amazonaws.com"
        }
        Effect    = "Allow"
        Sid       = ""
      },
    ]
  })

  tags = {
    Name = "cloudwatch-role"
  }
}

resource "aws_iam_role_policy_attachment" "cloudwatch_policy" {
  role       = aws_iam_role.cloudwatch_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}

resource "aws_iam_role_policy_attachment" "cloudtrail_policy" {
  role       = aws_iam_role.cloudwatch_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCloudTrailFullAccess"
}
