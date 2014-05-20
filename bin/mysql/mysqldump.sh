#!/bin/bash
dir=$(dirname `readlink -f $0`)
list=(`cat "$dir/tables"`)
list=${list[@]}
db=juwai

#mysqldump -u root -p -h 127.0.0.1 --opt -d --dump-date=FALSE  $db | sed 's/ AUTO_INCREMENT=[0-9]*\b//' > struct_$db.sql

for table in ${list[@]};
	do mysqldump -h 127.0.0.1 -u root -pmysql111 -t $db $table > $dir/db/data_$db_$table.sql;
done
