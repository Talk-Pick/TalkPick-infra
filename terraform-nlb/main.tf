// Network Load Balancer
resource "aws_lb" "talkpick_nlb" {
  name               = var.nlb_name
  load_balancer_type = "network"
  subnets            = var.public_subnet_ids
  internal           = false

  tags = {
    Name = "${var.name_prefix}-nlb"
  }
}

// NLB Target Group
resource "aws_lb_target_group" "talkpick_nlb_tg" {
  name        = var.target_name     // target name
  port        = var.target_port // target port
  protocol    = "TCP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    protocol            = "TCP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 10
  }

  tags = {
    Name = "${var.name_prefix}-nlb-tg"
  }
}

// Attach EC2 (Private IPs) to Target Group
resource "aws_lb_target_group_attachment" "talkpick_nlb_tg_attachment" {
  count            = length(var.ec2_private_ips)
  target_group_arn = aws_lb_target_group.talkpick_nlb_tg.arn
  target_id        = var.ec2_private_ips[count.index]
  port             = var.target_port
}

// NLB Listener
resource "aws_lb_listener" "talkpick_nlb_listener" {
  load_balancer_arn = aws_lb.talkpick_nlb.arn
  port              = var.listener_port
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.talkpick_nlb_tg.arn
  }
}