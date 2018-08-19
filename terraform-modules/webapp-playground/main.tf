
resource "aws_alb" "playground" {
  name            = "playground"
  internal        = false
  security_groups = ["${aws_security_group.alb_playground.id}"]
  subnets         = ["${var.subnet_public_A}","${var.subnet_public_B}"]

  tags {
    Name        = "playground ALB"
  }
}

resource "aws_alb_listener" "playground" {
  load_balancer_arn = "${aws_alb.playground.arn}"
  port              = 80
  protocol          = "HTTP"


  default_action {
    target_group_arn = "${aws_alb_target_group.playground.arn}"
    type             = "forward"
  }
}

resource "aws_alb_target_group" "playground" {
  name     = "playground"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "traffic-port"
    interval            = 30
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_security_group" "alb_playground" {
    vpc_id = "${var.vpc_id}"
    name = "ALB playground"
}

resource "aws_security_group_rule" "access_from_internet" {
    type        = "ingress"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = "${aws_security_group.alb_playground.id}"
}

resource "aws_security_group_rule" "access_to_ec2" {
    type        = "egress"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    source_security_group_id = "${aws_security_group.ec2_playground.id}"
    security_group_id = "${aws_security_group.alb_playground.id}"
}

resource "aws_security_group" "ec2_playground" {
  vpc_id = "${var.vpc_id}"
    name = "EC2 playground"
}

resource "aws_security_group_rule" "access_from_the_alb" {
    type        = "ingress"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    source_security_group_id = "${aws_security_group.alb_playground.id}"
    security_group_id = "${aws_security_group.ec2_playground.id}"
}

resource "aws_security_group_rule" "surf_the_internet1" {
    type        = "egress"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = "${aws_security_group.ec2_playground.id}"
}
resource "aws_security_group_rule" "surf_the_internet2" {
    type        = "egress"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = "${aws_security_group.ec2_playground.id}"
}

resource "aws_instance" "playground" {
    ami             = "${var.my_ami}"
    instance_type   = "t2.micro"
    key_name        = "${var.pem_key_name}"
    subnet_id       = "${var.subnet_private}"
    security_groups = ["${aws_security_group.ec2_playground.id}"]
    user_data       = <<EOF
#!/bin/bash
yum install httpd -y
echo "This is a playground main directory" > /var/www/html/index.html
mkdir -p /var/www/html/subdir
echo "This is a sub directory" > /var/www/html/subdir/index.html
service httpd start
EOF
}

# Attach the proxy instances
resource "aws_lb_target_group_attachment" "playground" {
  target_group_arn = "${aws_alb_target_group.playground.arn}"
  target_id        = "${aws_instance.playground.id}"
  port             = 80
}
