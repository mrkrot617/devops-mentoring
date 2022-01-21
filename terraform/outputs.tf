output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.jenkins.id
}

output "user_data" {
  description = "User data"
  value       = aws_instance.jenkins.user_data
}

output "credit_specification" {
  description = "credit_specification"
  value       = aws_instance.jenkins.credit_specification
}

output "password" {
  description = "password"
  value       = aws_instance.jenkins.get_password_data
}

output "private_ip" {
  description = "private_ip"
  value       = aws_instance.jenkins.private_ip
}