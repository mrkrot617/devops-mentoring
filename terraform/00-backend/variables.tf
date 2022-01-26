variable "aws_provider_profile" {
  description = "AWS profile"
  default     = "default"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  default     = "us-east-2"
  type        = string
}

variable "backend_bucket_name" {
  description = "S3 bucket name for remote state"
  default     = "mentoring-terraform-states"
  type        = string
}