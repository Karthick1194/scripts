#!/bin/bash

# Add the backup dir location, MySQL root password, MySQL and mysqldump location
DATE=$(date +%d-%m-%Y)
BACKUP_DIR="/home/ec2-user/dailybackup/"
MYSQL_USER="root"
MYSQL_PASSWORD="mysecret"
DATABASE_NAME='karthick'
MYSQL="$(which mysql)"

# To create a new directory in the backup directory location based on the date
mkdir -p $BACKUP_DIR/$DATE

# To get a list of databases
databases=`$MYSQL -u$MYSQL_USER -p$MYSQL_PASSWORD -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema)"`

# To dump each database in a separate file
for db in $DATABASE_NAME; do
echo $DATABASE_NAME
#mysqldump --force --opt --skip-lock-tables --user=$MYSQL_USER -p$MYSQL_PASSWORD --databases $db | gzip > "$BACKUP_DIR/$DATE/$db.sql.gz"

mysqldump --force --opt --skip-lock-tables --user=$MYSQL_USER -p$MYSQL_PASSWORD --databases $DATABASE_NAME | gzip > "$BACKUP_DIR/$DATE/$db.sql.gz"

done

# Delete the files older than 10 days
find $BACKUP_DIR/* -type d -mtime +10 -exec rm {} \;
