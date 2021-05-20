#!/bin/bash

TIME=`date +%b-%d-%y`                      # This Command will read the date.
f1=backup-$TIME.tar    # The filename including the date.
f2=backup-$TIME.tar.gz	#find the gzipped file
echo "Enter the source path like /var/www/html" #Source backup folder
read -r SRCDIR

echo "Enter the Destination Path like /backup " # Destination of backup file.
read -r DESDIR

tar -cpzf $DESDIR/$f1 $SRCDIR

gzip $DESDIR/$f1

#find $FILENAME -mtime -1 -type f -print &> /dev/null

find $DESDIR/$f2 -mtime -1 -type f -print

if [ $? -eq 0 ]

then
	echo Backup was created
	echo
	echo Archiving backup 
	echo " Backup completed successfully"
else
	echo Backup failed
fi
