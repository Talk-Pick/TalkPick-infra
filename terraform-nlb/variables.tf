variable "name_prefix" {
  description = "Talkpick default prefix"
  type        = string
  default     = "talkpick"
}

variable "nlb_name" {
  description = "NLB name"
  type = string
}

variable "target_name" {
  description = "NLB Target group name"
  type = string
}

variable "public_subnet_ids" {
  description = "List of Public Subnets"
  type = list(string)
}

variable "vpc_id" {
  description = "VPC id"
  type = string
}

variable "target_port" {
  description = "NLB target port"
  type = number
}

variable "listener_port" {
  description = "NLB listen port"
  type = number
}

variable "ec2_private_ips" {
  description = "List of EC2 private IPs to attach to the target group"
  type        = list(string)
}