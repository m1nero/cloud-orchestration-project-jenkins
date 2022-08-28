#!/bin/bash

sudo su - 
yum update -y
yum install yum-utils -y

yum install docker -y
usermod -aG docker ec2-user 

curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

chkconfig docker on
service docker start
