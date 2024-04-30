#!/bin/bash

# Install Apache
apt update
apt install -y apache2
systemctl start apache2
systemctl enable apache2

echo "HelloWorld" > /var/www/html