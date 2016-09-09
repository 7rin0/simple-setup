#!/bin/bash

PROJECT_ROOT='/var/www/application'

# Setup a Symfony 3 project
sudo curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony
sudo chmod a+x /usr/local/bin/symfony
sudo cp -f /vagrant/config/symfony/parameters.yml /var/www/application/app/config/parameters.yml
sudo mysql -u root -proot -h localhost -e'create database symfony_3'
sudo chmod -R 777 $PROJECT_ROOT/app/cache
sudo chmod -R 777 $PROJECT_ROOT/app/logs
sudo sed -i "s/'127.0.0.1'/'127.0.0.1', '192.168.55.55'/g" $PROJECT_ROOT/web/app_dev.php

# Set params
sudo cp -f /vagrant/config/symfony/symfony_3.conf /etc/apache2/sites-available/symfony_3.conf
sudo a2ensite symfony_3
sudo service apache2 restart -y
