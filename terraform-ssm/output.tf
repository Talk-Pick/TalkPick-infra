// Call by Root
output "instance_profile_name" {
  value = aws_iam_instance_profile.talkpick_ssm_profile.name
}