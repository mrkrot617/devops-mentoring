variable "aws_region" {
  description = "AWS app region"
  default     = "us-east-1"
  type        = string
}

variable "key_name" {
  description = "Generated key name"
  default     = "project_key"
  type        = string
}

variable "key_path" {
  description = "Path to the generated key"
  default     = "../../../"
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

variable "default_username" {
  description = "Default username for EC2 instance (Amazon Linux 2)"
  default     = "ec2-user"
  type        = string
}