#!/bin/bash

### Script to automatically delete recordings from TVHeadend and filesystem
### after they are watched in XBMC
###  https://github.com/andyb2000

## Config is in the seperate config.inc file, please make all changes in there

. config.inc

#########################################################################################

echo "  Autodelete script for XBMC and TVHeadend"
echo "  By Andy Brown - https://github.com/andyb2000"
echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="

if [ "x$CONFIG" == "x" ]; then
	echo "ERROR: Config file was not loaded, aborting now"
	exit 1
fi

if [ "$TESTING" == "1" ]; then
	echo "TESTING mode enabled. Delete will NOT take place"
else
	echo "Live - Delete will take place"
fi

sleep 3

if [ "$TYPE" == "mysql" ]; then
	## MySQL processing
	if [ "x$MYSQL_DB" == "x" ]; then
		## DB is blank so use autodetection
		MYSQL_DB=`mysqldump --skip-quote-names --skip-comments -N -c -A -n -t -d -u $MYSQL_USER --password=$MYSQL_PASS |grep MyVideos | awk '{print \$2;}' | cut -d ";" -f 1 | tail -n1`
	fi
	echo "Mysql database: $MYSQL_DB"
	LIST_FILES=`mysqldump --skip-quote-names --skip-comments --skip-extended-insert -N -c -n -u $MYSQL_USER --password=$MYSQL_PASS $MYSQL_DB files --where="playCount>0" | cut -d "," -f 8,9 |grep "'"`
	for file_entry in $LIST_FILES
	do
		# echo "Entry: '$file_entry'"
		CHK_FILE=`echo "$file_entry" | cut -d "'" -f 2`
		FINDER=`find $PATH_TO_RECORDINGS -type f -mtime +$DAYS_TO_DELETE -name "$CHK_FILE" 2>/dev/null`
		if [ "x$FINDER" != "x" ]; then
			echo "DELETE:  $FINDER"
			if [ "$TESTING" == "0" ]; then
				DORM=`rm -f '$FINDER'`
			fi
			CHK_TVH=`grep $FINDER $PATH_TO_TVHEADEND_CONFIG/tvheadend/dvr/log/* | cut -d ":" -f 1`
			if [ "x$CHK_TVH" != "x" ]; then
				echo "Find in TVH: $CHK_TVH"
				if [ "$TESTING" == "0" ]; then
					DORM=`rm -f '$CHK_TVH'`
				fi
			fi
		fi
	done
else
	## SQLITE processing
	if [ "x$SQDB_DB" == "x" ]; then
                ## DB is blank so use autodetection
		SQDB_DB=`ls $SQDB_PATH/userdata/Database/MyVideos*.* | sort -n | tail -1`
        fi
	echo "SQLite database: $SQDB_DB"
	LIST_FILES=`echo 'select strFilename from files where playCount>0;' | sqlite3 -noheader -batch -csv $SQDB_DB`
	for file_entry in $LIST_FILES
        do
                # echo "Entry: '$file_entry'"
		CHK_FILE=`echo "$file_entry"`
                FINDER=`find $PATH_TO_RECORDINGS -type f -mtime +$DAYS_TO_DELETE -name "$CHK_FILE" 2>/dev/null`
                if [ "x$FINDER" != "x" ]; then
                        echo "DELETE:  $FINDER"
			if [ "$TESTING" -eq 0 ]; then
                                DORM=`rm -f '$FINDER'`
                        fi
                        CHK_TVH=`grep $FINDER $PATH_TO_TVHEADEND_CONFIG/tvheadend/dvr/log/* | cut -d ":" -f 1`
                        if [ "x$CHK_TVH" != "x" ]; then
                                echo "Find in TVH: $CHK_TVH"
				if [ "$TESTING" -eq 0 ]; then
                                        DORM=`rm -f '$CHK_TVH'`
                                fi
                        fi
                fi
        done

fi
