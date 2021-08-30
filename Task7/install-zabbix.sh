#!/bin/bash

echo "=== User Data start ==="

# https://www.zabbix.com/documentation/5.0/manual/installation/install_from_packages/debian_ubuntu

###########################################################
# VARIABLES -- CHANGE THINGS HERE
###########################################################
ZABBIX_PKG_NAME="zabbix-release_5.0-1+bionic_all.deb"
ZABBIX_REPO_URL="https://repo.zabbix.com/zabbix/5.0/ubuntu/pool/main/z/zabbix-release"

DB_HOST="localhost"
DB_PORT=3306
DB_USER="zabbix" # change your zabbix database username as needed
DB_PASS="zabbix" # change your zabbix database password as needed
DB_NAME="zabbix" # change your zabbix database name as needed
ZBX_SERVER_HOST="localhost"

DB_SERVER_HOST=${DB_HOST}
DB_SERVER_PORT=${DB_PORT}
DB_SERVER_DBNAME=${DB_NAME}
MYSQL_USER=${DB_USER}
MYSQL_PASSWORD=${DB_PASS}
MYSQL_DATABASE=${DB_NAME}

ZBX_LOADMODULE=""
ZBX_DEBUGLEVEL=5
ZBX_TIMEOUT=10

# ***** THERE IS NO NEED TO CHANGE ANYTHING AFTER THIS POINT **** #

###########################################################
# COMMON
###########################################################
AWS_INSTANCE_ID=`curl -s http://169.254.169.254/latest/meta-data/instance-id`
TEMP_INSTALL_DIR="/root/install"

sudo mkdir ${TEMP_INSTALL_DIR}
sudo cd ${TEMP_INSTALL_DIR}
sudo wget ${ZABBIX_REPO_URL}/${ZABBIX_PKG_NAME}
sudo dpkg -i ${ZABBIX_PKG_NAME}

# update OS
sudo mv /boot/grub/menu.lst /tmp/
sudo update-grub-legacy-ec2 -y
sudo apt-get -y dist-upgrade
sudo apt -y update
sudo apt full-upgrade -y

###########################################################
# MySQL INSTALLATION AND CONFIGURATION FOR ZABBIX
###########################################################

sudo apt install zabbix-server-mysql -y
sudo cp -pd /etc/zabbix/zabbix_server.conf /etc/zabbix/zabbix_server.conf.orig

sudo service zabbix-server start
sudo update-rc.d zabbix-server enable

###########################################################
# ZABBIX FRONTEND
###########################################################

sudo apt install apache2 -y
sudo apt install php libapache2-mod-php -y
sudo update-rc.d apache2 enable
sudo service apache2 start

sudo apt install zabbix-frontend-php -y
sudo service apache2 restart

###########################################################
# ZABBIX DATA
###########################################################

cd ${TEMP_INSTALL_DIR}

sudo apt install mysql-server -y
sudo service mysql start
sudo update-rc.d mysql enable

sudo echo "CREATE DATABASE IF NOT EXISTS ${DB_NAME} CHARACTER SET utf8 COLLATE utf8_bin;" > ${TEMP_INSTALL_DIR}/create_zabbix.sql
sudo echo "GRANT ALL ON *.* TO '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';" >> ${TEMP_INSTALL_DIR}/create_zabbix.sql
sudo echo "FLUSH PRIVILEGES;" >> ${TEMP_INSTALL_DIR}/create_zabbix.sql
sudo mysql -u root > ${TEMP_INSTALL_DIR}/create_zabbix.sql

sudo zcat /usr/share/doc/zabbix-server-mysql/create.sql.gz | mysql -u root ${DB_NAME}

###########################################################
# ZABBIX AGENT
###########################################################

sudo apt install zabbix-agent -y
sudo service zabbix-agent start

###########################################################
# ZABBIX CONFIG
###########################################################

sudo cat > /etc/apache2/conf-available/zabbix.conf <<EOF
#
# Zabbix monitoring system php web frontend
#
Alias /zabbix /usr/share/zabbix
<Directory "/usr/share/zabbix">
    Options FollowSymLinks
    AllowOverride None
    Require all granted
    <IfModule mod_php7.c>
        php_value max_execution_time 300
        php_value memory_limit 512M
        php_value post_max_size 128M
        php_value upload_max_filesize 128M
        php_value max_input_time 300
        php_value max_input_vars 10000
        php_value always_populate_raw_post_data -1
        php_value date.timezone America/Toronto
    </IfModule>
</Directory>
<Directory "/usr/share/zabbix/conf">
    Require all denied
</Directory>
<Directory "/usr/share/zabbix/app">
    Require all denied
</Directory>
<Directory "/usr/share/zabbix/include">
    Require all denied
</Directory>
<Directory "/usr/share/zabbix/local">
    Require all denied
</Directory>
EOF
sudo ln -s /etc/apache2/conf-available/zabbix.conf /etc/apache2/conf-enabled/zabbix.conf

###########################################################
# RESTART ZABBIX AND APACHE
###########################################################

sudo service zabbix-server restart
sudo service apache2 restart
sudo service zabbix-agent restart

echo "=== User Data end ==="

# End;