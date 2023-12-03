#!/bin/bash

# abntt

agent="Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/116.0"

login(){
	IFS=$oIFS
	i=($i)
	sleep 2
	pin=`curl -sA "$agent" -d "logging_in=1&nation=${i[0]}&password=${i[1]}&submit=Login" -c - "https://www.nationstates.net/region=a_better_name_than_that" | tee sticktmp | tail -n 1 | awk '$1=="#HttpOnly_.nationstates.net"{print $7}'` && echo "Logged into '${i[0]}'"
	id=`grep localid sticktmp`
	id=${id:43}
	id=`echo $id | rev`
	id=${id:2}
	id=`echo $id | rev`
	sleep 2
	curl -sA "$agent" -d "localid=$id&region_name=$region&move_region=1" --cookie "pin=$pin" https://www.nationstates.net/page=change_region >> /dev/null && echo "Moved '${i[0]}'"
}

oIFS=$IFS
IFS=$'\n'
for i in `cat nationlog`; do
	login
	rm sticktmp
done
