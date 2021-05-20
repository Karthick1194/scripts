################################################################
##
##   Content and DB backup script
##   Written By: Karthick Raja Ramasamy
##   Last Update: May20 2021
##
################################################################

#!/bin/bash
#!/usr/bin/python


TIME=`date +%b-%d-%y`                      # This Command will read the date.
TODAY=`date +"%d%b%Y"`
FILENAME=backup-$TIME.tar.gz    # The filename including the date.
DBFILENAME=DB_backup-$TODAY
SRCDIR=/var               # Source backup folder.
DESDIR=/home/ec2-user/dailybackup          # Destination of backup file.
tar -cpzf $DESDIR/$FILENAME $SRCDIR

DB_BACKUP_PATH='/home/ec2-user/dailybackup/'
MYSQL_HOST='localhost'
MYSQL_PORT='3306'
MYSQL_USER='root'
MYSQL_PASSWORD='mysecret'
DATABASE_NAME='karthick'
BACKUP_RETAIN_DAYS=30   ## Number of days to keep local backup copy

mkdir -p ${DB_BACKUP_PATH}/${DBFILENAME}
echo "Backup started for database - ${DATABASE_NAME}"

mysqldump --force --opt --skip-lock-tables --user=$MYSQL_USER -p$MYSQL_PASSWORD --databases $DATABASE_NAME | gzip > "$DB_BACKUP_PATH/$DBFILENAME/$DATABASE_NAME.sql.gz"

if [ $? -eq 0 ]; then
	echo "Databse backup successfully completed"
else
	echo "Error found during backup "
	exit 1
fi

##### Remove backups older than {BACKUP_RETAIN_DAYS} days  #####

DBDELETE=`date +"+%b-%d-%y" --date="${BACKUP_RETAIN_DAYS} days ago"`

if [ ! -z ${DB_BACKUP_PATH} ]; then
	cd  ${DB_BACKUP_PATH}
	if  [ ! -z ${DBDELETE} ] && [ -d ${DBDELDATE} ]; then
		rm -rf ${DBDELETE}
	fi
fi

####################################


echo "copying the backups to s3 location"

( exec "/home/ec2-user/s3-backup.sh" )

#sh /home/ec2-user/s3-backup.sh

if [ $? -eq 0 ]; then
	echo "backups successfully moved to s3 "
else
	echo "error !!! check the valid key id's"
	exit 1
fi
