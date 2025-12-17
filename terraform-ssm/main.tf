// IAM Role: CCW-PRIVATE-EC2-SSM
resource "aws_iam_role" "talkpick_ssm_role" {
  // for iam role config
  name = var.ssm_instance_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17" 
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

// IAM Role Attachement
resource "aws_iam_role_policy_attachment" "talkpick_ssm_attach" {
  role       = aws_iam_role.talkpick_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

// IAM Role Profile for EC2
resource "aws_iam_instance_profile" "talkpick_ssm_profile" {
  name = var.ssm_instance_role_name
  role = aws_iam_role.talkpick_ssm_role.name
}