FROM debian:11

RUN apt update && apt upgrade -y

RUN apt install -y git gcc php-cli

WORKDIR /opt

RUN git clone https://github.com/Kutabarik/olymp-sandbox.git
