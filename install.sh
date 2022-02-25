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

apt-add-repository "deb https://download.docker.com/linux/debian $(lsb_release -cs) stable"

apt-get update
if [ $? -ne 0 ]; then
	echo "ERROR: apt update (FAILED)"
	exit $?
fi
apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -q -y install docker-ce docker-compose git curl wget pwgen 
if [ $? -ne 0 ]; then
	echo "ERROR: apt install of docker and utilites (FAILED)"
	exit $?
fi

MYSQL_BITRIX_PASSWORD=`pwgen 10 1`
MYSQL_ROOT_PASSWORD=`pwgen 10 1`
PUSH_SECURITY_KEY=`pwgen 20 1`

HOSTNAME=`cat /etc/hostname`

#echo "Create folder struct"
mkdir -p ${BITRIX_LOG_DIR}/nginx
mkdir -p ${BITRIX_LOG_DIR}/mysql
mkdir -p ${BITRIX_LOG_DIR}/memcached
mkdir -p ${BITRIX_LOG_DIR}/sphinxsearch

mkdir -p ${BITRIX_MAIN_DIR}/www
mkdir -p ${BITRIX_MAIN_DIR}/www/bitrix
mkdir -p ${BITRIX_MAIN_DIR}/mysql
mkdir -p ${BITRIX_MAIN_DIR}/memcached
mkdir -p ${BITRIX_MAIN_DIR}/sphinxsearch

trap 'cleanup' SIGTERM
trap 'cleanup' EXIT

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
PUSH_SECURITY_KEY=${PUSH_SECURITY_KEY}
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

push pub/sub KEY:
   ${PUSH_SECURITY_KEY}

start bitrix24: 
  cd ${BITRIX_MAIN_DIR}/bitrix24-docker; docker-compose build; docker-compose up -d;

stop bitrix24:
  cd ${BITRIX_MAIN_DIR}/bitrix24-docker; docker-compose down;

show bitrix24 logs:
  cd ${BITRIX_MAIN_DIR}/bitrix24-docker; docker-compose logs --follow;

http bitrix24 (битрикс): 
  http://${HOSTNAME}

EOF


cat <<EOF

Bitrix24 MySQL server setup information:

  host       = db
  port       = 3306
  
  user       = bitrix
  password   = ${MYSQL_BITRIX_PASSWORD}
  
  super_user = root
  password   = ${MYSQL_ROOT_PASSWORD}

start bitrix24: 
  cd ${BITRIX_MAIN_DIR}/bitrix24-docker; docker-compose build; docker-compose up -d;

stop bitrix24:
  cd ${BITRIX_MAIN_DIR}/bitrix24-docker; docker-compose down;

show bitrix24 logs:
  cd ${BITRIX_MAIN_DIR}/bitrix24-docker; docker-compose logs --follow;

http bitrix24 (запуск инсталлятора битрикс24): 
  http://${HOSTNAME}

настройки докер и пароли:
  /var/lib/bitrix24/bitrix24-docker/.env
  /var/lib/bitrix24/bitrix24-docker/docker-compose.yml
  
push pub/sub KEY:
   ${PUSH_SECURITY_KEY}
EOF

cat > /var/lib/bitrix24/www/bitrix/.settings_extra.php <<EOF
<?php
return array (

'cache' => array(
      'value' => array(
          'type' => array(
              'class_name' => '\\Bitrix\\Main\\Data\\CacheEngineMemcache',
              'extension' => 'memcache'
          ),
          'memcache' => array(
              'host' => 'memcached',
              'port' => '11211',
          ),
          'sid' => $_SERVER["DOCUMENT_ROOT"]."#01"
      ),
  ),

);
?>
EOF
