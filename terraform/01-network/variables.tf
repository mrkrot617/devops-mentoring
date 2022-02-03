variable "aws_region" {
  description = "AWS app region"
  default     = "us-east-1"
  type        = string
}

variable "aws_provider_profile" {
  description = "AWS profile"
  default     = "default"
  type        = string
}