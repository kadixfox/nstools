#!/bin/bash

## i dont know if this ever worked but the situation with the captcha was hilarious

agent="Mozilla/5.0 (Nintendo Wii; U; ; 3642; en) AppleWebKit/601.1 (KHTML, like Gecko) Tesla QtCarBrowser PaleMoon/27.1.2"
name="acc+node+"
password="hh"
region="antarctica_compute_cluster"
for i in {0..129}; do
	echo "running for $name$i"
	pin=`curl -sA "$agent" -d "logging_in=1&nation=$name$i&password=$password&submit=Login" -c - https://www.nationstates.net/region=$region | tee damn | tail -n1 | awk '$1=="#HttpOnly_.nationstates.net"{print $7}'`
	echo "pin: $pin"
	id=`grep localid damn`
	id=${id:43}
	id=`echo $id | rev`
	id=${id:2}
	id=`echo $id | rev`
	echo "id: $id"
	sleep 4
	curl -sA "$agent" -d "join_faction=1" --cookie "pin=$pin" https://www.nationstates.net/page=faction/fid=511
	sleep 4
done
