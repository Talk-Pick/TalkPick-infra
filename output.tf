output "github_actions_access_key" {
  value = module.iam.iam_github_actions_access_id
}

output "github_actions_secret_key" {
  value     = module.iam.iam_github_actions_access_secret
  sensitive = true
}