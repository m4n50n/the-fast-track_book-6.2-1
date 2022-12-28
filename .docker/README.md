
```shell
docker-compose up
```

Si se quiere dejar en segundo plano, añadir `-d`.

Podemos usar `docker exec` o `docker-compose exec`.

```shell
docker-compose images
docker-compose exec php bash
docker-compose exec php composer -V
docker-compose exec php symfony -v
docker-compose exec php php -v
docker-compose exec php php -i
docker-compose exec php symfony check:requirements
```
