# CACHE=--no-cache
CACHE=

help:
	@echo "usage:"
	@echo "  make init - prepare infrastructure"
	@echo "  make build - build project"
	@echo "  make up - up solution"
	@echo "  make rebuild - down build up"
	@echo "  make full-rebuild - down clean build up"
	@echo "  make down - stop containers and remove"
	@echo "  make stop - stop containers"
	@echo "  make mariadb - build mariadb image"
	@echo "  make php-fpm - build php-fpm image"
	@echo "  make sandbox - build sandbox image"
	@echo "  make nginx - build nginx image"
	@echo "  make sandbox-bash - run bash into sandbox"
	@echo "  make help - show this help"

init:
	@echo "prepare structure" ; \
	mkdir -p ./mounts/data ./mounts/database ; \
	git submodule init ; \
	git submodule update ; \
	echo "done"

build:
	@echo "build project images" ; \
	docker-compose --file docker-compose.yml build ${CACHE}; \
	echo "done"

up:
	@echo "up project" ; \
	docker-compose -f docker-compose.yml up -d ; \
	echo "project is up. access http://localhost"

rebuild: down build up

full-rebuild: down clean build up

clean:
	rm -Rf ./mounts/data/*
	rm -Rf ./mounts/database/*

down:
	@echo "down project" ; \
	docker-compose -f docker-compose.yml down --remove-orphans; \
	echo "project is down"

stop:
	@echo "stop containers" ; \
	docker-compose -f docker-compose.yml stop; \
	echo "done"

mariadb:
	@echo "build mariadb image"; \
	docker-compose --file docker-compose.yml build ${CACHE} mariadb; \
	echo "done"

php-fpm:
	@echo "build php-fpm image"; \
	docker-compose --file docker-compose.yml build ${CACHE} php-fpm; \
	echo "done"

sandbox:
	@echo "build sandbox image"; \
	docker-compose --file docker-compose.yml build ${CACHE} sandbox; \
	echo "done"

nginx:
	@echo "build nginx image"; \
	docker-compose --file docker-compose.yml build ${CACHE} nginx; \
	echo "done"


sandbox-bash:
	@echo "run sandbox bash"; \
	docker-compose exec -it sandbox bash

