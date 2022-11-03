#!/bin/bash

sudo yum -y update
sudo yum install -y mysql

# Install Apache
sudo yum -y install httpd
sudo systemctl enable --now httpd


# Install PHP
sudo yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
sudo yum -y install epel-release


# Install PHP 7.4 REMI repository

sudo yum -y install yum-utils
sudo yum-config-manager --disable remi-php54
sudo yum-config-manager --enable remi-php74
sudo yum -y install php php-{cli,gd,mysqlnd,mbstring,json,common,dba,dbg,devel,embedded,enchant,bcmath,gmp,intl,ldap,odbc,pdo,opcache,pear,pgsql,process,recode,snmp,soap,xml,xmlrpc}


# Install wget and Drupal 9
sudo yum install -y wget
sudo wget https://www.drupal.org/download-latest/tar.gz -O drupal.tar.gz
sudo tar xvf drupal.tar.gz
sudo rm -f drupal*.tar.gz
sudo mv drupal-*/  /var/www/html/drupal

# Create Drupal directories
sudo mkdir /var/www/html/drupal/sites/default/files
sudo cp /var/www/html/drupal/sites/default/default.settings.php /var/www/html/drupal/sites/default/settings.php

# Change ownership of drupal directory
sudo chown -R apache:apache /var/www/html/

# Create Drupal directories
sudo mkdir /var/www/html/drupal/sites/default/files
sudo cp /var/www/html/drupal/sites/default/default.settings.php /var/www/html/drupal/sites/default/settings.php

# Change ownership of drupal directory
sudo chown -R apache:apache /var/www/html/
sudo chmod -R 755 /var/www/html/

# Install Drupal config file
sudo wget https://shrine-dev-files-001.s3.amazonaws.com/drupal.conf -O /etc/httpd/conf.d/drupal.conf


# Fix SELinux Labels:
sudo semanage fcontext -a -t httpd_sys_rw_content_t "/var/www/html/drupal(/.*)?"
sudo semanage fcontext -a -t httpd_sys_rw_content_t '/var/www/html/drupal/sites/default/settings.php'
sudo semanage fcontext -a -t httpd_sys_rw_content_t '/var/www/html/drupal/sites/default/files'
sudo restorecon -Rv /var/www/html/drupal
sudo restorecon -v /var/www/html/drupal/sites/default/settings.php
sudo restorecon -Rv /var/www/html/drupal/sites/default/files

# Restart apache httpd
sudo service httpd restart

# Temporary Disable SELinux to allow database login for Drupal database

sudo setenforce 0
