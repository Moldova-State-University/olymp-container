FROM php:8.1-zts

# RUN echo "deb http://deb.debian.org/debian buster contrib non-free" > /etc/apt/sources.list.d/buster.list \
#    && echo "deb http://deb.debian.org/debian buster-updates contrib non-free" > /etc/apt/sources.list.d/buster.updates.list

RUN apt update && apt upgrade -y && apt install -y git gcc g++ make nano

WORKDIR /opt

RUN git clone https://github.com/Kutabarik/olymp-sandbox.git \
    && cd olymp-sandbox \
    && git checkout winlin \
    && make \
    && cp bin/olymp-sandbox /usr/local/bin
 RUN pecl install parallel \
    && docker-php-ext-enable parallel

COPY ./files/ /opt/files/

CMD ["php","/opt/files/index.php"]