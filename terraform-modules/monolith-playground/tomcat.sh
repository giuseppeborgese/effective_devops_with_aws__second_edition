#!/bin/bash
case $1 in
 start)
 # start script
 runuser -l ec2-user -c 'export db_pass=some_pass; export db_user=monty; export db_url=jdbc:mysql://localhost:3306/demodb?createDatabaseIfNotExist=true; java -jar /home/ec2-user/demo-0.0.1-SNAPSHOT.jar &'
 ;;
 stop)
 # stop script
 pkill java
 ;;
esac
exit
