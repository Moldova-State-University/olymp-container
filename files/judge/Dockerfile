FROM php:8.1-zts

RUN apt update && apt upgrade -y && apt install -y git gcc g++ make nano \
    && docker-php-ext-install -j$(nproc) pdo pdo_mysql \
	&& docker-php-ext-enable pdo pdo_mysql

RUN pecl install parallel \
    && docker-php-ext-enable parallel

COPY submodules/sandbox /opt/

RUN cd /opt/sandbox && make \
    && cp bin/olymp-sandbox /usr/local/bin

WORKDIR /opt/olymp-sandbox

CMD ["php","/opt/sandbox/manager/index.php"]