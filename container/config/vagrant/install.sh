#!/bin/bash

# Set global variables
export DEBIAN_FRONTEND=noninteractive
export COMPOSER_ALLOW_SUPERUSER=1
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# http://www.cyberciti.biz/faq/ubuntu-linux-14-04-install-php7-using-apt-get-command/
# https://github.com/oerdnj/deb.sury.org/issues/56
# Setup simple lamp environment.
# Install PHP.
sudo apt-get update && apt-get install -y language-pack-en-base && export LC_ALL=en_US.UTF-8 && export LANG=en_US.UTF-8 && apt-get install -y software-properties-common && add-apt-repository -y ppa:ondrej/php && add-apt-repository -y ppa:ondrej/mariadb-10.0 && apt-get update && apt-get -y upgrade -y
sudo apt-get install php7.0 -y
sudo apt-get install php7.0 php7.0-cli php7.0-fpm php7.0-gd php7.0-json php7.0-mysql php7.0-readline -y
sudo apt-get install php7.0-curl -y
sudo apt-get install php7.0-mbstring

# Update packages
sudo apt-get -f install -y
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y build-essential

# Install Apache
sudo apt-get install apache2 apache2-doc apache2-utils -y

# Install MySQL and set default variables
echo mysql-server mysql-server/root_password select root | sudo debconf-set-selections
echo mysql-server mysql-server/root_password_again select root | sudo debconf-set-selections
sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile
sudo apt-get install mysql-server -y

# Install LAMP
sudo sed -i -e '1 i\ ServerName localhost ' /etc/apache2/apache2.conf
sudo a2enmod rewrite
sudo service apache2 restart -y

# Install server requirements
sudo apt-get install zip -y
sudo apt-get install git -y

# Install NodeJS packages
# https://nodejs.org/en/download/package-manager/
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install nodejs -y

# PHP dependencies manager
sudo curl -sS https://getcomposer.org/installer | php && sudo mv composer.phar /usr/bin/composer
sudo composer config -g github-oauth.github.com f0502ecd3d7c8e7e47223616c177b869180a3e05
# Front dependencies manager
sudo npm install -g bower
sudo gem install sass

# Install Elasticsearch
# FOSELastica doesnt support Elasticsearch > 2
sudo apt-get install openjdk-7-jre -y
wget https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-1.7.3.deb
sudo dpkg -i elasticsearch-1.7.3.deb
rm -rf elasticsearch-1.7.3.deb
# [TEST] curl -X GET http://localhost:9200/
cd /usr/share/elasticsearch
sudo bin/plugin install mobz/elasticsearch-head

# OPTIONAL
# installs add-apt-repository
# http://hhvm.com/blog/3095/getting-wordpress-running-on-hhvm
sudo apt-get install software-properties-common
sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0x5a16e7281be7a449
sudo add-apt-repository "deb http://dl.hhvm.com/ubuntu $(lsb_release -sc) main"
sudo apt-get update
sudo apt-get install hhvm

# PHPUnit
wget https://phar.phpunit.de/phpunit.phar
chmod +x phpunit.phar
sudo mv phpunit.phar /usr/local/bin/phpunit

# Install cache accelerators and server services
sudo apt-get install php5-memcache memcached php-pear -y
sudo pecl install memcache
echo "extension=memcache.so" | sudo tee /etc/php5/apache2/conf.d/memcache.ini

### Project Auto Installer ###
## Add all possible hosts to machine to avoid duplications
sudo cat /vagrant/config/vagrant/hosts | sudo tee --append /etc/hosts

# Restart services
sudo /etc/init.d/apache2 restart -y

# Setup Application requirements
sh /vagrant/config/vagrant/requirements.sh

# Add phalconphp
# https://docs.phalconphp.com/en/latest/reference/install.html
curl -s https://packagecloud.io/install/repositories/phalcon/stable/script.deb.sh | sudo bash
sudo apt-get install php7.0-phalcon
php -m | grep 'phalcon'
