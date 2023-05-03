#!/bin/bash

sleep 5
cd /var/www/html
php bin/console --no-interaction doctrine:migrations:migrate

php-fpm