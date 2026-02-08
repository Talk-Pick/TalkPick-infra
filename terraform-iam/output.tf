output "iam_github_actions_access_id" {
  description = "IAM Access ID for Github Actions"
  value       = aws_iam_access_key.talkpick_github_actions_key.id
}

output "iam_github_actions_access_secret" {
  description = "IAM Access Key for Github Actions"
  value       = aws_iam_access_key.talkpick_github_actions_key.secret
  sensitive = true
}
