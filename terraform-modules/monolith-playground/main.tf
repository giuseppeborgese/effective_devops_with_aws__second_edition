resource "aws_instance" "playground" {
  ami           = "ami-04681a1dbd79675a5"
  instance_type = "t2.micro"
  user_data     = "${file("install.sh")}"
  vpc_security_group_ids = ["${aws_security_group.playground.id}"]
  subnet_id = "${var.my_subnet}"
  tags {
    Name = "Monolith Playground"
  }
}

resource "aws_security_group" "playground" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = "${var.my_vpc_id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}
