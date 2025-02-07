# resource "aws_s3_bucket" "terraform_backend" {
#   bucket = "devsecops-practice-backend-bucket"  # Ensure this is globally unique

#   tags = {
#     Name        = "Terraform State Bucket"
#     Environment = "Dev"
#   }
# }

# resource "aws_s3_bucket_versioning" "versioning" {
#   bucket = aws_s3_bucket.terraform_backend.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
#   bucket = aws_s3_bucket.terraform_backend.id

#   rule {
#     apply_server_side_encryption_by_default {
#       sse_algorithm = "AES256"
#     }
#   }
# }
