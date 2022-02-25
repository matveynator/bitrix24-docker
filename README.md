# Bitrix24 in Docker in Debian 10 and 11.
Bitrix24 in Docker with SSMTP, SPHINX, MYSQL, NGINX, PHP74.
На данный момент (25.02.2022) это единственный и самый перспективный рабочий способ установить 
Bitrix24 не используя рекомендованные и тормозные VMWare виртуальные машины, так как проект CENTOS 
прикратил свое существование и установка на чистую CENTOS не представляется возможным.

### INSTALL:
```
curl -L https://raw.githubusercontent.com/matveynator/bitrix24-docker/main/install.sh | sudo bash
```

### http (9080)
по этому порту 9080 будет доступен инсталлятор bitrix
```
  http://IP:9080 
  http://localhost:9080
```

### данные mysql:
данные храняться в /var/lib/bitrix24/mysql
```
  host: db
  port: 3306
  user: bitrix (пароль сгенерирует инсталлятор в предыдущем шаге)
  db: bitrix (использовать существующую)
```

### memcahed:
используйте для хранения кэша
```
  host: memcached
  port: 11211
```

### sphinx search:
используйте для ускорения поиска по документам
```
  host: sphinx
  port: 9306
```

  
