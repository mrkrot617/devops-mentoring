output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.jenkins.id
}

output "private_ip" {
  description = "Private ip of the EC2 instance"
  value       = aws_instance.jenkins.private_ip
}

output "public_ip" {
  description = "Public ip of the EC2 instance"
  value       = aws_instance.jenkins.public_ip
}

output "default_username" {
  description = "Default username for Amazon Linux 2"
  value = "ec2-user"
}