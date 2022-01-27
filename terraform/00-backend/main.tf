provider "aws" {
  profile = var.aws_provider_profile
  region  = var.aws_region
}

resource "aws_s3_bucket" "remote_state" {
  bucket = var.backend_bucket_name

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "remote_state_policy" {
  bucket = aws_s3_bucket.remote_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "terraform_lock" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "local_file" "remote_state_config" {
  content = "bucket = \"${var.backend_bucket_name}\"\nregion = \"${var.aws_region}\"\ndynamodb_table = \"${var.dynamodb_table_name}\""
  filename = "../dev-s3-backend-config.hcl"
}