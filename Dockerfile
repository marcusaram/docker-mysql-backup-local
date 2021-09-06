FROM alpine:3

ARG GOCRONVER=v0.0.10
ARG TARGETOS
ARG TARGETARCH
RUN set -x \
	&& apk update && apk add ca-certificates curl tzdata mysql-client mariadb-connector-c gzip openssl \
	&& curl -L https://github.com/prodrigestivill/go-cron/releases/download/$GOCRONVER/go-cron-linux-amd64-static.gz | zcat > /usr/local/bin/go-cron \
	&& chmod a+x /usr/local/bin/go-cron

ENV MYSQL_DB="**None**" \
    MYSQL_DB_FILE="**None**" \
    MYSQL_HOST="**None**" \
    MYSQL_PORT=3306 \
    MYSQL_USER="**None**" \
    MYSQL_USER_FILE="**None**" \
    MYSQL_PASSWORD="**None**" \
    MYSQL_PASSWORD_FILE="**None**" \
    MYSQL_PASSFILE_STORE="**None**" \
    MYSQL_EXTRA_OPTS="-q" \
    SCHEDULE="@daily" \
    BACKUP_DIR="/backups" \
    BACKUP_SUFFIX=".sql.gz" \
    BACKUP_KEEP_DAYS=7 \
    BACKUP_KEEP_WEEKS=4 \
    BACKUP_KEEP_MONTHS=6 \
    HEALTHCHECK_PORT=8080

COPY backup.sh /backup.sh

VOLUME /backups

ENTRYPOINT ["/bin/sh", "-c"]
CMD ["exec /usr/local/bin/go-cron -s \"$SCHEDULE\" -p \"$HEALTHCHECK_PORT\" -- /backup.sh"]

HEALTHCHECK --interval=5m --timeout=3s \
  CMD curl -f "http://localhost:$HEALTHCHECK_PORT/" || exit 1
