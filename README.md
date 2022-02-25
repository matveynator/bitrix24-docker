# Bitrix24 in Docker in Debian 10 and 11.
Bitrix24 in Docker with SSMTP, SPHINX, MYSQL, NGINX, PHP74.

### INSTALL:
```
curl -L https://raw.githubusercontent.com/matveynator/bitrix24-docker/main/install.sh | sudo bash
```

### http (9080)
```
  http://IP:9080 
  http://localhost:9080
```
по этому порту 9080 будет доступен инсталлятор bitrix

### данные mysql:
```
  mysql host: db
  mysql user: bitrix (пароль сгенерирует инсталлятор в предыдущем шаге)
  mysql db: bitrix (использовать существующую)
```
