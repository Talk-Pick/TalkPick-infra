// EC2 Security Group
resource "aws_security_group" "talkpick_ec2_sg" {
  name        = "${var.name_prefix}-ec2-sg"
  description = "Allow traffic from NLB and SSH from EICE only"
  vpc_id      = var.vpc_id

  # HTTP inbound allow for NLB
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks = var.public_subnets_cidr
  }

  # HTTPS inbound allow for NLB, SSM 
  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks = var.public_subnets_cidr
  }

  # SSH inbound allow for EICE 
    ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.eice_sg.id]
  }

  # all outbound allow
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-ec2-sg"
  }
}


// EC2 Instance Connect Endpoint Security Group 
resource "aws_security_group" "eice_sg" {
  name   = "${var.name_prefix}-eice-sg"
  vpc_id = var.vpc_id

  # ssh outbound allow
  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-eice-sg"
  }
}

// EC2 In Private Subnets
resource "aws_instance" "talkpick_private_ec2" {
  // config for ec2
  ami           = "ami-0b818a04bc9c2133c"
  instance_type = "t3.micro"

  subnet_id = var.private_subnet_ids[0]  # AZ-a
  
  // security group 
  vpc_security_group_ids = [
    aws_security_group.talkpick_ec2_sg.id
  ]

  // bash script
  user_data = <<-EOF
    #!/bin/bash
    echo "root:TalkkpickkA!!@" | chpasswd
  EOF

  tags = {
    Name = "${var.name_prefix}-server-1"
  }
}

// EC2 Instance Connect Endpoint 
resource "aws_ec2_instance_connect_endpoint" "talkpick_eice" {
  subnet_id = var.private_subnet_ids[0] # AZ-a
  security_group_ids = [
    aws_security_group.eice_sg.id
  ]

  tags = {
    Name = "${var.name_prefix}-eice"
  }
}