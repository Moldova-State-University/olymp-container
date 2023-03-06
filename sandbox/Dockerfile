FROM debian:11

RUN apt update && apt upgrade -y

RUN apt install -y git gcc g++ make php-cli cron nano

WORKDIR /opt

RUN git clone https://github.com/Kutabarik/olymp-sandbox.git \
    && cd olymp-sandbox \
    && git checkout winlin \
    && make \
    && cp bin/olymp-sandbox /usr/local/bin

# register cron job
COPY sample.sh /opt/sample.sh
COPY cronjob /etc/crontab

ENTRYPOINT ["/opt/sample.sh"]
CMD ["cron","-f", "-l", "2"]