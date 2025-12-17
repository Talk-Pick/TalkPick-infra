variable "name_prefix" {
  description = "Talkpick default prefix"
  type        = string
  default     = "talkpick"
}

variable "subnet_ids" {
  type        = list(string)
  default     = []
}

variable "availability_zones" {
  type        = list(string)
  default     = []
}

variable "vpc_id" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "instance_class" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_port" {
  type = number
}

variable "ec2_security_group_id" {
    type = string
}