![Docker Pulls](https://img.shields.io/docker/pulls/oxar/mysql-backup-local)

# mysql-backup-local

[Source](https://github.com/marcusaram/docker-mysql-backup-local)

Backup MySQL to the local filesystem with periodic rotating backups, based on [prodrigestivill/docker-postgres-backup-local](https://github.com/prodrigestivill/docker-postgres-backup-local).
Backup multiple databases from the same host by setting the database names in `MYSQL_DB` separated by commas or spaces.
This image works also on environments where containers are not running as root, such as OpenShift.

## Usage

Docker:

```sh
docker run -e MYSQL_HOST=MYSQL -e MYSQL_DB=dbname -e MYSQL_USER=user -e MYSQL_PASSWORD=password  oxar/mysql-backup-local
```

### Environment Variables


| env variable | description |
|--|--|
| BACKUP_DIR | Directory to save the backup at. Defaults to `/backups`. |
| BACKUP_SUFFIX | Filename suffix to save the backup. Defaults to `.sql.gz`. |
| BACKUP_KEEP_DAYS | Number of daily backups to keep before removal. Defaults to `7`. |
| BACKUP_KEEP_WEEKS | Number of weekly backups to keep before removal. Defaults to `4`. |
| BACKUP_KEEP_MONTHS | Number of monthly backups to keep before removal. Defaults to `6`. |
| HEALTHCHECK_PORT | Port listening for cron-schedule health check. Defaults to `8080`. |
| MYSQL_DB | Comma or space separated list of MYSQL databases to backup. Required. |
| MYSQL_DB_FILE | Alternative to MYSQL_DB, but with one database per line, for usage with docker secrets. |
| MYSQL_EXTRA_OPTS | Additional options for `mysqldump` |
| MYSQL_HOST | MySQL connection parameter; MySQL host to connect to. Required. |
| MYSQL_PASSWORD | MySQL connection parameter; MySQL password to connect with. Required. |
| MYSQL_PASSWORD_FILE | Alternative to MYSQL_PASSWORD, for usage with docker secrets. |
| MYSQL_PORT | MYSQL connection parameter; MySQL port to connect to. Defaults to `5432`. |
| MYSQL_USER | MYSQL connection parameter; MySQL user to connect with. Required. |
| MYSQL_USER_FILE | Alternative to MYSQL_USER, for usage with docker secrets. |
| SCHEDULE | [Cron-schedule](http://godoc.org/github.com/robfig/cron#hdr-Predefined_schedules) specifying the interval between MYSQL backups. Defaults to `@daily`. |
| TZ | [POSIX TZ variable](https://www.gnu.org/software/libc/manual/html_node/TZ-Variable.html) specifying the timezone used to evaluate SCHEDULE cron (example "Europe/Paris"). |


### Manual Backups

By default this container makes daily backups, but you can start a manual backup by running `/backup.sh`.

This script as example creates one backup as the running user and saves it the working folder.

```sh
docker run --rm -v "$PWD:/backups" -u "$(id -u):$(id -g)" -e MYSQL_HOST=MYSQL -e MYSQL_DB=dbname -e MYSQL_USER=user -e MYSQL_PASSWORD=password  oxar/mysql-backup-local /backup.sh
```

### Automatic Periodic Backups

You can change the `SCHEDULE` environment variable in `-e SCHEDULE="@daily"` to alter the default frequency. Default is `daily`.

More information about the scheduling can be found [here](http://godoc.org/github.com/robfig/cron#hdr-Predefined_schedules).

Folders `daily`, `weekly` and `monthly` are created and populated using hard links to save disk space.

