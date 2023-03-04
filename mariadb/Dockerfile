FROM mariadb:10.8

ARG MYSQLDUMP_FILE=db_init.sql.gz

RUN apt update && apt -y upgrade

# COPY ./backups/${MYSQLDUMP_FILE} /docker-entrypoint-initdb.d/mysqldump.sql.gz