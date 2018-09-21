
yum -y install httpd mariadb.x86_64 mariadb-server
echo "<VirtualHost *>" > /etc/httpd/conf.d/tomcat-proxy.conf
echo "        ProxyPass               /visits      http://localhost:8080/visits" >> /etc/httpd/conf.d/tomcat-proxy.conf
echo "        ProxyPassReverse       /visits      http://localhost:8080/visits" >> /etc/httpd/conf.d/tomcat-proxy.conf
echo "</VirtualHost>" >> /etc/httpd/conf.d/tomcat-proxy.conf
systemctl start mariadb
chkconfig httpd on
chkconfig mariadb on
service httpd restart
mysql -u root -e "create database demodb;"
mysql -u root -e "CREATE TABLE visits (id bigint(20) NOT NULL AUTO_INCREMENT, count bigint(20) NOT NULL, version bigint(20) NOT NULL, PRIMARY KEY (id)) ENGINE=InnoDB DEFAULT CHARSET=latin1;" demodb
mysql -u root -e "INSERT INTO demodb.visits (count) values (0) ;"
mysql -u root -e "CREATE USER 'monty'@'localhost' IDENTIFIED BY 'some_pass';"
mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'monty'@'localhost' WITH GRANT OPTION;"
runuser -l ec2-user -c 'cd /home/ec2-user ; curl -O https://raw.githubusercontent.com/giuseppeborgese/effective_devops_with_aws__second_edition/master/chapter6/demo-0.0.1-SNAPSHOT.jar'
echo "runuser -l ec2-user -c 'export db_pass=some_pass; export db_user=monty; export db_url=jdbc:mysql://localhost:3306/demodb?createDatabaseIfNotExist=true; java -jar /home/ec2-user/demo-0.0.1-SNAPSHOT.jar' " >> /etc/rc.d/rc.local
bash /etc/rc.d/rc.local
