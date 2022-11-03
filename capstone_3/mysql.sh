#!/bin/bash
user=admin
password=Welcome$
rds=$"{rds}"

# Create MySQL Tables on RDS Instance
mysql -u admin -pWelcome$ -h $rds -e 'CREATE DATABASE drupal;'
mysql -u admin -pWelcome$ -h $rds -e 'GRANT ALL PRIVILEGES ON drupal.* TO 'drupal'@'localhost' IDENTIFIED BY 'Welcome$';'
mysql -u admin -pWelcome$ -h $rds -e 'FLUSH PRIVILEGES;'