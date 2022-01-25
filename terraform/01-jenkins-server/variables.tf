variable "key_name" {
  description = "Generated key name"
  default     = "project_key"
  type        = string
}

variable "ami_id" {
  description = "Amazon Linux 2 (us-east-1)"
  default     = "ami-08e4e35cccc6189f4"
  type        = string
}

variable "aws_provider_profile" {
  description = "AWS profile"
  default     = "default"
  type        = string
}