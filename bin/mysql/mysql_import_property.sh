#!/bin/bash
db=juwai
dir=/data/sql/"$db"_property
list=(`ls -1 "$dir"`)
list=${list[@]}

for table in ${list[@]};
	do mysql -h 127.0.0.1 -u root -pmysql111 -f --database $db < $dir/$table;
done
