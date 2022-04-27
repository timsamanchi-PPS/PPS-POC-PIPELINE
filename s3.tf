# create s3 bucket
# acl: private
# versioning: true
# encryption: true
locals {
  bucket-suffix = "ts-test"
}
resource "aws_s3_bucket" "artifacts" {
    bucket = var.artifacts-bucket
    force_destroy = true
    tags = {
      Name = "test"
    }
}
resource "aws_s3_bucket_acl" "acl" {
    bucket = aws_s3_bucket.artifacts.id
    acl = "private"
}
resource "aws_s3_bucket_versioning" "versioning" {
    bucket = aws_s3_bucket.artifacts.id
    versioning_configuration {
        status = "Enabled"
    }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
    bucket = aws_s3_bucket.artifacts.id
    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
        }
    }
}
