output "ec2_private_ips" {
  description = "Private IPs of Talkpick EC2 instances"
  value       = aws_instance.talkpick_private_ec2[*].private_ip
}

output "ec2_instance_ids" {
  description = "Instance IDs of Talkpick EC2 instances"
  value       = aws_instance.talkpick_private_ec2[*].id
}

output "ec2_security_group_id" {
  description = "Output Security Group ID for Talkpick EC2 info"
  value       = aws_security_group.talkpick_ec2_sg.id
}