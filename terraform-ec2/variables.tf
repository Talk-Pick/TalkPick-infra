variable "name_prefix" {
  description = "Talkpick default prefix"
  type        = string
  default     = "talkpick"
}

variable "vpc_id" {
  description = "VPC id"
  type = string
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = []
}

variable "public_subnet_cidrs" {
    description = "VPC Public Subnet CIDR"
    type = list(string)
    default = []
}

variable "sg_name" {
  description = "Security group name for ec2"
  type = string
}
