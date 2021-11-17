#!/bin/bash

# install httpd (Linux 2 version)
yum update -y
yum install -y vim
yum install -y git
amazon-linux-extras install -y epel
amazon-linux-extras install -y nginx1
yum install -y certbot
yum install -y python-certbot-nginx
yum install -y nodejs

service nginx start