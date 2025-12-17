// RDS Security Group 
resource "aws_security_group" "talkpick_rds_security_group" {
  name = "${var.name_prefix}-rds-sg"
  vpc_id = var.vpc_id

  // allow mysql inbound 
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [var.ec2_security_group_id]
  }

  // allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-rds-sg"
  }
}

// RDS Private Subnet Group
resource "aws_db_subnet_group" "talkpick_rds_subnet_group" {
  name        = "${var.name_prefix}-rds-subnet-group"
  subnet_ids  = var.subnet_ids 
  description = "A subnet group for Talkpick RDS instance"

  tags = {
    Name = "${var.name_prefix}-rds-subnet-group"
  }
}

// RDS In Private Subnets
resource "aws_db_instance" "talkpick_private_rds" {
  identifier           = "${var.name_prefix}-rds-instance"
  instance_class       = var.instance_class
  allocated_storage    = 20
  storage_type         = "gp2"
  engine         = "mysql"
  engine_version = "8.0.41"
  publicly_accessible  = false // deny public access

  // network security 
  db_subnet_group_name = aws_db_subnet_group.talkpick_rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.talkpick_rds_security_group.id]
  
  // config mariadb
  username = var.db_username
  password = var.db_password
  db_name              = var.db_name
  port                 = var.db_port

  skip_final_snapshot  = true // config backup
  backup_retention_period = 0 // snapshot skip
  multi_az             = false 
  
  tags = {
    Name    = "${var.name_prefix}-rds-instance"
    Engine  = "Mysql"
  }
}  