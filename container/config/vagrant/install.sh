#!/bin/bash

# Later this script will be split into parts, clusters and for some services a dedicated container is also being prepared and tested ...

# Set global variables
export DEBIAN_FRONTEND=noninteractive
export COMPOSER_ALLOW_SUPERUSER=1
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Installation Scripts
## OS (apt-get)
## Services (servers, profilers)
## RUBY (gems, bundler)
## PHP (composer, php modules)
## JAVA (modules, applications, services)
## JS, CSS, NodeJS (frameworks and services)
## Frameworks (frameworks and services)
## Project Management (Gitlab, Redmine)

# http://www.cyberciti.biz/faq/ubuntu-linux-14-04-install-php7-using-apt-get-command/
# https://github.com/oerdnj/deb.sury.org/issues/56
# Setup simple lamp environment.
# Install PHP.
set -gx  LC_ALL en_US.UTF-8
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

# Install vagrant and virtualbox package for tests purposes
sudo apt-get install virtualbox -y
VAGRANT_FILENAME = 'vagrant_1.8.6_x86_64.deb'
wget https://releases.hashicorp.com/vagrant/1.8.6/$VAGRANT_FILENAME
sudo dpkg -i $VAGRANT_FILENAME
sudo dpkg -i $VAGRANT_FILENAME

# Install libmagick
sudo apt-get install libmagickwand-dev imagemagick -y
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

# Install ruby >= 2.0
# Required gems
# https://rubygems.org/gems/json/versions/2.0.1
sudo apt-add-repository ppa:brightbox/ruby-ng
sudo apt-get install ruby-dev -y
sudo gem install bundler
sudo gem install json
sudo gem install mysql2
sudo gem install sass

# Install globaly required npm packages.
sudo npm install -g bower
sudo npm install -g http-server
# http://loopback.io/ && https://strongloop.com/
sudo npm install -g strongloop
# IBM API Connect https://developer.ibm.com/apiconnect/
sudo npm install -g apiconnect
# http://sailsjs.org/
sudo npm install -g sails
# log
sudo npm install -g log.io --user "vagrant"
sudo screen -d -m log.io-server
sudo screen -d -m log.io-harvester

# Install Elasticsearch
# FOSELastica doesnt support Elasticsearch > 2
sudo apt-get install openjdk-7-jre -y
wget https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-1.7.3.deb
sudo dpkg -i elasticsearch-1.7.3.deb
rm -rf elasticsearch-1.7.3.deb
# [TEST] curl -X GET http://localhost:9200/
cd /usr/share/elasticsearch
sudo bin/plugin install mobz/elasticsearch-head

# Install SOLR:8983
# https://www.howtoforge.com/tutorial/how-to-install-and-configure-solr-on-ubuntu-1604/
cd /tmp
wget http://apache.crihan.fr/dist/lucene/solr/6.2.1/solr-6.2.1.tgz
tar xzvf solr-6.2.1.tgz
sudo bash solr-6.2.1/bin/install_solr_service.sh solr-6.2.1.tgz
sudo service solr status
# http://wiki.apache.org/solr/DataImportHandler
sudo wget http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.39.tar.gz


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

# Install Phalcon tools
git clone git://github.com/phalcon/phalcon-devtools.git ~/phalcon-devtools
sudo ln -s ~/phalcon-devtools/phalcon.php /usr/bin/phalcon
chmod ugo+x /usr/bin/phalcon

# Install Gitlab
# http://bundler.io/
# https://about.gitlab.com/downloads/#ubuntu1404
# http://gitlab.vm/help/ci/yaml/README.md#jobs
# http://serverfault.com/questions/143968/automate-the-installation-of-postfix-on-ubuntu
# gitlab.vm
debconf-set-selections <<< "postfix postfix/mailname string simple-setup.local"
debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"
sudo apt-get install curl openssh-server ca-certificates postfix -y
curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash
sudo apt-get install gitlab-ce -y
sudo gitlab-ctl reconfigure
# alter unicorn port to 8081
# Add gitlab runner
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-ci-multi-runner/script.deb.sh | sudo bash
sudo apt-get install gitlab-ci-multi-runner -y
# Run this command manually, token is expected
# sudo gitlab-ci-multi-runner register

# Install Rake
sudo apt-get install rake
sudo bundle install

# Add issue tracker
# http://www.redmine.org/projects/redmine/wiki/redmineinstall
# bundle exec rails server webrick -b 192.168.55.55 -e production
cd ~
git clone https://github.com/redmine/redmine
cd redmine/public/themes
git clone https://github.com/Nitrino/flatly_light_redmine.git
mysql -u root -proot -e "create database redmine character set utf8; create user 'redmine'@'localhost' identified by 'root'; grant all privileges on redmine.* to 'redmine'@'localhost';"
cp /vagrant/config/redmine/database.yml config/database.yml

# Add services manager on reboot
sudo chmod +x /vagrant/config/vagrant/os_boot.sh
(crontab -l 2>/dev/null; echo "@reboot sh /vagrant/config/vagrant/os_boot.sh") | crontab -

# Fish
sudo apt-get install fish
# curl -L http://get.oh-my.fish | fish
# omf install bobthefish
chsh -s /usr/bin/fish

# Server automation.
# git://github.com/ansible/ansible.git
sudo apt-get install software-properties-common
sudo apt-add-repository ppa:ansible/ansible -y
sudo apt-get update
sudo apt-get install ansible

# Docker
sudo apt-get install apt-transport-https ca-certificates
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" | sudo tee /etc/apt/sources.list.d/docker.list
sudo apt-get update
sudo apt-get install docker-engine -y
sudo service docker start

# Add Jenkins container
# https://hub.docker.com/_/jenkins/
sudo docker run -p 8085:8085 -p 50000:50000 jenkins
