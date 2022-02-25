# Bitrix24 in Docker in Debian 10 and 11.
Bitrix24 in Docker with SSMTP, SPHINX, MYSQL, NGINX, PHP74.

### INSTALL:
```
curl -L https://raw.githubusercontent.com/matveynator/bitrix24-docker/main/install.sh | sudo bash
```

### Bitrix24 MySQL server information:
```
  host     = 127.0.0.1
  port     = 3306
  user     = root
  password = /root/.my.cnf 
  config   = /var/lib/bitrix24/bitrix24-docker/mysql/my.cnf
  binlogs  = /var/log/bitrix24/mysql
  data     = /var/lib/bitrix24/mysql
```

### start bitrix24:
```
  cd /var/lib/bitrix24/bitrix24-docker; docker-compose build; docker-compose up -d;
```

### stop bitrix24:
```
  cd /var/lib/bitrix24/bitrix24-docker; docker-compose down;
```
### show bitrix24 logs:
```
cd /var/lib/bitrix24/bitrix24-docker; docker-compose logs --follow;
```

### http bitrix24 (add nginx proxy with ssl localy): 
```
  http://IP:9080
```
