#!/bin/bash

apt update 
apt install apache2 -y
echo "test" > /var/www/html/index.html
systemctl restart apache2
systemctl enable apache2