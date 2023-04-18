FROM php:8.1-fpm

ARG DATABASE_URL

ENV PHP_EXT='soap gd intl mysqli pdo_mysql zip'

# prepare environment, install php extensions
RUN apt-get update && apt upgrade -y

RUN apt-get install -y libmemcached-dev zlib1g-dev libxml2-dev libpng-dev libzip-dev git \
    && pecl install memcached-3.2.0 \
    && docker-php-ext-install -j$(nproc) ${PHP_EXT} \
	&& docker-php-ext-enable memcached ${PHP_EXT}

# enable healthcheck
RUN sed --in-place "s|;pm.status_path = /status|pm.status_path = /status|g" \
    /usr/local/etc/php-fpm.d/www.conf

RUN echo "DATABASE_URL=${DATABASE_URL}\n" > /var/www/html/.env \
    && echo "APP_SECRET=secret\n" >> /var/www/html/.env \
    && echo "MESSENGER_TRANSPORT_DSN=doctrine://default\n" >> /var/www/html/.env

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
	php /usr/local/bin/composer self-update

RUN curl -fsSL https://deb.nodesource.com/setup_current.x | bash - &&\
    apt-get install -y nodejs

WORKDIR /opt

RUN git clone https://github.com/devrdn/olymp-platform.git && mv olymp-platform/server/* /var/www/html

WORKDIR /var/www/html

RUN composer install && npm install \
    && php bin/console make:migration \
    && php bin/console doctrine:migrations:migrate
