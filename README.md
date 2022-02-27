# Bitrix24 in Docker in Debian 10 and 11.
Bitrix24 in Docker with SSMTP, SPHINX, MEMCACHED, LDAP, MYSQL, NGINX, PHP74, PUSH & PULL.
На данный момент (25.02.2022) это  можно сказать единственный рабочий способ установить 
bitrix24 не используя vmware виртуальные машины, так как проект CENTOS прикратил свое 
существование и установка на чистую CENTOS не представляется возможным.

<img src="https://repository-images.githubusercontent.com/463467104/1dee8021-e984-4165-950b-5b44fd789504" width="50%">

### INSTALL:
```
curl -L https://raw.githubusercontent.com/matveynator/bitrix24-docker/main/install.sh | sudo bash
```

### http (80)
по этому порту (80) будет доступен инсталлятор bitrix
```
  http://IP 
  http://localhost
  http://domain.com
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

### PUSH & PULL server
используется для audio/video/chat 
код-подпись для взаимодействия с сервером (PUSH_SECURITY_KEY) генерируется в процессе установки.
Необходима донастройка nginx https://training.bitrix24.com/support/training/course/?COURSE_ID=178&LESSON_ID=21618
```
PUB host: http://push-server-pub
SUB host: http://push-server-sub

Путь для публикации команд сервером:   http://push-server-pub/bitrix/pub
Путь для чтения команд сервером:     http://push-server-sub/bitrix/subws

Путь для публикации команд клиентом:   http://DOMAIN.COM/push-server-pub/bitrix/pub
Путь для чтения команд клиентом:   http://DOMAIN.COM/push-server-pub/bitrix/subws
```

### ssl сертификаты (https://github.com/matveynator/sysadminscripts/wiki/Free-SSL-Certs): 
```
curl https://get.acme.sh | sh
/root/.acme.sh/acme.sh --set-default-ca  --server  zerossl
/root/.acme.sh/acme.sh --register-account -m security@domain.com
/root/.acme.sh/acme.sh -w /var/lib/bitrix24/www --issue -d domain.com -d www.domain.com
```

### расположение сертификатов для nginx (volume /root/.acme.sh:/root/.acme.sh:ro):
```
ssl_certificate /root/.acme.sh/domain.com/fullchain.cer;
ssl_certificate_key /root/.acme.sh/domain.com/domain.com.key;
```

Остальные сисадминские скрипты и записки (wiki) можно найти тут: https://github.com/matveynator/sysadminscripts

