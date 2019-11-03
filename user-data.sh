#!/bin/sh
yum install -y httpd
systemctl enable --now httpd
echo "Created manually - $(hostname -f)" > /var/www/html/index.html
