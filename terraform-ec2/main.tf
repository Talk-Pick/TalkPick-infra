// EC2 Security Group
resource "aws_security_group" "talkpick_ec2_sg" {
  name        = "${var.name_prefix}-ec2-sg"
  description = "Allow traffic from NLB only"
  vpc_id      = var.vpc_id

  # HTTP from NLB only
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks = var.public_subnets_cidr
  }

  # HTTPS from NLB only
  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks = var.public_subnets_cidr
  }

  # outbound allow
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

// EC2 In Private Subnets
resource "aws_instance" "talkpick_private_ec2" {
  // loop
  count = length(var.private_subnet_ids)

  // config for ec2
  ami           = "ami-0b818a04bc9c2133c"
  instance_type = "t3.micro"
  subnet_id     = var.private_subnet_ids[count.index] // vpc subnet id 
  iam_instance_profile = var.ec2_instance_profile
  
  // security group 
  security_groups = [aws_security_group.talkpick_ec2_sg.id]

  // bash script
  user_data = <<-EOF
    #!/bin/bash
    echo "root:TalkkpickkA!!@" | chpasswd
    # install nginx
    sudo yum install -y nginx
    sudo systemctl enable --now nginx
    echo "<h1>Welcome to Talkpick Instance: $(hostname -I)</h1>" > /usr/share/nginx/html/index.html
  EOF

  tags = {
    Name = "${var.name_prefix}-app-${count.index + 1}"
  }
}