#!/bin/bash
db=juwai
dir=/data/sql/"$db"_base
list=(`ls -1 "$dir"`)
list=${list[@]}

#mysql -u root -pmysql111 -h127.0.0.1 --database $db < $dir/struct_$db.sql;

for table in ${list[@]};
	do mysql -h 127.0.0.1 -u root -pmysql111 -f --database $db < $dir/$table;
done
