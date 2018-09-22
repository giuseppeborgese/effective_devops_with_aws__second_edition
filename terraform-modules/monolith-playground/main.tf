resource "aws_instance" "playground" {
  ami           = "${var.my_ami_id}"
  instance_type = "t2.micro"
  user_data = <<EOF
#!/bin/bash
yum -y install httpd mariadb.x86_64 mariadb-server java
echo "<VirtualHost *>" > /etc/httpd/conf.d/tomcat-proxy.conf
echo "        ProxyPass               /visits      http://localhost:8080/visits" >> /etc/httpd/conf.d/tomcat-proxy.conf
echo "        ProxyPassReverse       /visits      http://localhost:8080/visits" >> /etc/httpd/conf.d/tomcat-proxy.conf
echo "</VirtualHost>" >> /etc/httpd/conf.d/tomcat-proxy.conf
systemctl start mariadb
chkconfig httpd on
chkconfig mariadb on
systemctl restart httpd
mysql -u root -e "create database demodb;"
mysql -u root -e "CREATE TABLE visits (id bigint(20) NOT NULL AUTO_INCREMENT, count bigint(20) NOT NULL, version bigint(20) NOT NULL, PRIMARY KEY (id)) ENGINE=InnoDB DEFAULT CHARSET=latin1;" demodb
mysql -u root -e "INSERT INTO demodb.visits (count) values (0) ;"
mysql -u root -e "CREATE USER 'monty'@'localhost' IDENTIFIED BY 'some_pass';"
mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'monty'@'localhost' WITH GRANT OPTION;"
runuser -l ec2-user -c 'cd /home/ec2-user ; curl -O https://raw.githubusercontent.com/giuseppeborgese/effective_devops_with_aws__second_edition/master/terraform-modules/monolith-playground/demo-0.0.1-SNAPSHOT.jar'
runuser -l ec2-user -c 'cd /home/ec2-user ; curl -O https://raw.githubusercontent.com/giuseppeborgese/effective_devops_with_aws__second_edition/master/terraform-modules/monolith-playground/tomcat.sh'
cd /etc/systemd/system/ ; curl -O https://raw.githubusercontent.com/giuseppeborgese/effective_devops_with_aws__second_edition/master/terraform-modules/monolith-playground/tomcat.service
chmod +x /home/ec2-user/tomcat.sh
systemctl enable tomcat.service
systemctl start tomcat.service
EOF
  vpc_security_group_ids = ["${aws_security_group.playground.id}"]
  subnet_id = "${var.my_subnet}"
  key_name  = "${var.my_pem_keyname}"
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

resource "aws_eip" "playground" {
  vpc      = true
  instance = "${aws_instance.playground.id}"
}
