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

output "ec2_user" {
  value = aws_instance.jenkins.user_data
}

output "ec2_user64" {
  value = aws_instance.jenkins.user_data_base64
}