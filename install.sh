#!/bin/sh

#plase edit this paths:
BITRIX_MAIN_DIR="/var/lib/bitrix24"
BITRIX_LOG_DIR="/var/log/bitrix24"


[ -d "${BITRIX_MAIN_DIR}" ] && echo "${BITRIX_MAIN_DIR} allready exists, please check manually" && exit 1

[ -d "${BITRIX_LOG_DIR}" ] && echo "${BITRIX_LOG_DIR} allready exists, please check manually" && exit 1

###################################


function cleanup () {
	if [ $? != "0" ]
		then
			echo "******************** Script failed! *********************** "
			echo "Removing ${BITRIX_MAIN_DIR} ${BITRIX_LOG_DIR} directories..."
			echo "************** Do you want to proceed??? ****************** "
			echo ""
			echo "Press any key to remove directories or CTRL+C to abort...   "
			read
        		rm -rf "${BITRIX_MAIN_DIR}"
			rm -rf "${BITRIX_LOG_DIR}"
			echo "Directories removed."
	fi
	
}
trap 'cleanup' SIGTERM
trap 'cleanup' EXIT

apt-get -y update
apt-get -y install git curl wget pwgen docker-ce

MYSQL_BITRIX_PASSWORD=`pwgen 10 1`
MYSQL_ROOT_PASSWORD=`pwgen 10 1`
HOSTNAME=`cat /etc/hostname`

#echo "Create folder struct"
mkdir -p ${BITRIX_LOG_DIR}/nginx
mkdir -p ${BITRIX_LOG_DIR}/mysql
mkdir -p ${BITRIX_LOG_DIR}/memcached
mkdir -p ${BITRIX_LOG_DIR}/sphinxsearch

mkdir -p ${BITRIX_MAIN_DIR}/www
mkdir -p ${BITRIX_MAIN_DIR}/mysql
mkdir -p ${BITRIX_MAIN_DIR}/memcached
mkdir -p ${BITRIX_MAIN_DIR}/sphinxsearch

chmod -R 775 ${BITRIX_MAIN_DIR}/www
chown -R root:www-data ${BITRIX_MAIN_DIR}/www

cd ${BITRIX_MAIN_DIR}/www;
wget https://www.1c-bitrix.ru/download/scripts/bitrixsetup.php;

cd ${BITRIX_MAIN_DIR}; 
git clone https://github.com/matveynator/bitrix24-docker.git;
cd ${BITRIX_MAIN_DIR}/bitrix24-docker

cat > ${BITRIX_MAIN_DIR}/bitrix24-docker/.env <<EOF
MYSQL_BITRIX_PASSWORD=${MYSQL_BITRIX_PASSWORD}
MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
SMTP_SMARTHOST=10.100.0.1
HOSTNAME=${HOSTNAME}
EOF

docker-compose build 
docker-compose up -d

cat >> /root/.my.cnf <<EOF
[client]
host     = 127.0.0.1
port     = 3306
user     = root
password = ${MYSQL_ROOT_PASSWORD}
EOF


cat >> /etc/info <<EOF

Bitrix24 MySQL server information:
  host     = 127.0.0.1
  port     = 3306
  user     = root
  password = /root/.my.cnf 
  config   = ${BITRIX_MAIN_DIR}/bitrix24-docker/mysql/my.cnf
  binlogs  = ${BITRIX_LOG_DIR}/mysql
  data     = ${BITRIX_MAIN_DIR}/mysql

start bitrix24: 
  cd ${BITRIX_MAIN_DIR}/bitrix24-docker; docker-compose build; docker-compose up -d;

stop bitrix24:
  cd ${BITRIX_MAIN_DIR}/bitrix24-docker; docker-compose down;

show bitrix24 logs:
  cd ${BITRIX_MAIN_DIR}/bitrix24-docker; docker-compose logs --follow;

EOF


cat <<EOF

Bitrix24 MySQL server information:
  host     = 127.0.0.1
  port     = 3306
  user     = root
  password = /root/.my.cnf 
  config   = ${BITRIX_MAIN_DIR}/bitrix24-docker/mysql/my.cnf
  binlogs  = ${BITRIX_LOG_DIR}/mysql
  data     = ${BITRIX_MAIN_DIR}/mysql

start bitrix24: 
  cd ${BITRIX_MAIN_DIR}/bitrix24-docker; docker-compose build; docker-compose up -d;

stop bitrix24:
  cd ${BITRIX_MAIN_DIR}/bitrix24-docker; docker-compose down;

show bitrix24 logs:
  cd ${BITRIX_MAIN_DIR}/bitrix24-docker; docker-compose logs --follow;

EOF
