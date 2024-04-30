#!/bin/bash

# Install Apache
sudo apt update
sudo apt install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2

sudo echo "HelloWorld" > ./index.html
sudo mv ./index.html /var/www/html/