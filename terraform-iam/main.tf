// IAM User for Github Acions
resource "aws_iam_user" "talkpick_github_actions" {
  name = "${var.name_prefix}-github-actions-deployer"
}

// IAM policy for SSM Deploy
resource "aws_iam_user_policy" "talkpick_ssm_deploy_policy" {
  name = "${var.name_prefix}-ssm-deploy-policy"
  user = aws_iam_user.talkpick_github_actions.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:SendCommand",
          "ssm:GetCommandInvocation",
          "ssm:ListCommandInvocations"
        ]
        Resource = "*" 
      },
      {
        Effect = "Allow"
        Action = "ec2:DescribeInstances"
        Resource = "*"
      }
    ]
  })
}

// IAM Access Key for Github Actions Access
resource "aws_iam_access_key" "talkpick_github_actions_key" {
  user = aws_iam_user.talkpick_github_actions.name
}