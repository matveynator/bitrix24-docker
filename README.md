# Bitrix24 in Docker in Debian 10 and 11.
Bitrix24 in Docker with SSMTP, SPHINX, MYSQL, NGINX, PHP74.
На данный момент (25.02.2022) это единственный и самый перспективный рабочий способ установить 
Bitrix24 не используя рекомендованные и тормозные VMWare виртуальные машины, так как проект CENTOS 
прикратил свое существование и установка на чистую CENTOS не представляется возможным.

<img src="https://repository-images.githubusercontent.com/463467104/1dee8021-e984-4165-950b-5b44fd789504" width="50%">

### INSTALL:
```
curl -L https://raw.githubusercontent.com/matveynator/bitrix24-docker/main/install.sh | sudo bash
```

### http (80)
по этому порту (80) будет доступен инсталлятор bitrix
```
  http://IP 
  http://domain.ru
  http://localhost
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

 
Остальные сисадминские скрипты можно найти тут: https://github.com/matveynator/sysadminscripts

А записную книжку сисадмина (с рецептами) можно прочитать здесь: https://github.com/matveynator/sysadminscripts/wiki

