#!/bin/bash

if [ $# -lt 6 ]; then
  echo "Exports data from mysql database in tables matching a like pattern e.g. 'table_%'"
  echo "Usage: $0 dbname dbhost dbuser dbpass pattern outputfile"
  exit 1
fi

DBNAME=$1
DBHOST=$2
DBUSER=$3
DBPASS=$4
PATTERN=$5
OUTPUTFILE=$6

TABLES=( `mysql -h$DBHOST -u$DBUSER -p$DBPASS $DBNAME --silent -e "show tables like '$PATTERN'"` )

for TABLE in "${TABLES[@]}"; do
  mysqldump -u$DBUSER -p$DBPASS $DBNAME $TABLE >> $OUTPUTFILE
done
