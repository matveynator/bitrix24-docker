#!/bin/sh
set -e

apt-get -y update
apt-get -y install git curl pwgen

MYSQL_BITRIX_PASSWORD=`pwgen 1 14`
MYSQL_ROOT_PASSWORD=`pwgen 1 14`
HOSTNAME=`cat /etc/hostname`

#echo "Create folder struct"
mkdir -p /var/log/bitrix24/nginx
mkdir -p /var/log/bitrix24/mysql
mkdir -p /var/log/bitrix24/memcached
mkdir -p /var/log/bitrix24/sphinxsearch
mkdir -p /var/lib/bitrix24/www
mkdir -p /var/lib/bitrix24/mysql
mkdir -p /var/lib/bitrix24/memcached
mkdir -p /var/lib/bitrix24/sphinxsearch
mkdir -p /var/lib/bitrix24/

chmod -R 775 /var/lib/bitrix24/www
chown -R root:www-data /var/lib/bitrix24/www

cd /var/lib/bitrix24/www;
wget https://www.1c-bitrix.ru/download/scripts/bitrixsetup.php;

cd /var/lib/bitrix24/; 
git clone https://github.com/matveynator/bitrix24-docker.git;
cd /var/lib/bitrix24/bitrix24-docker

cat /var/lib/bitrix24/bitrix24-docker/.env <<EOF
MYSQL_BITRIX_PASSWORD=${MYSQL_BITRIX_PASSWORD}
MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
SMTP_SMARTHOST=10.100.0.1
HOSTNAME=${HOSTNAME}
EOF
docker-compose build 
docker-compose up -d
