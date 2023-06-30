#!/bin/bash

sleep 5
cd /var/www/html
mkdir migrations/
php bin/console --no-interaction doctrine:migrations:diff
php bin/console --no-interaction doctrine:migrations:migrate

php-fpm