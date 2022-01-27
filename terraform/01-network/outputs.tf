output "vpc_id" {
  description = "ID of project VPC"
  value       = aws_vpc.project_vpc.id
}

output "subnet_id" {
  description = "ID of project subnet"
  value       = aws_subnet.project_subnet.id
}