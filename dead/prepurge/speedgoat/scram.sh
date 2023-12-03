#!/bin/bash
. config.sh
ratelmt(){
	if [ $addrandomrl == "true" ]; then
		sleep $(($scramrl + RANDOM % $scramrandrlrange))
	else
		sleep $scramrl
	fi
}
retry(){
	## This probably won't catch every possible issue and use case so if you're having problems, then idk what to tell you. I wrote this just to spite a person on the internet, not for some random skiddie to copy me.
	## EDIT: I have no fucking clue if this even works but im too lazy to make a situation in which it should
	echo "$name failed, trying again"
	## I hope you like segfaults
	go
}
go(){
	echo "running for $name"
	ratelmt
	pin=`curl $curlargs -sA "$htmlagent" -d "logging_in=1&nation=$name&password=$password&submit=Login" -c - https://www.nationstates.net/region=$scramregion | tee creds | tail -n1 | awk '$1=="#HttpOnly_.nationstates.net"{print $7}'` || retry
	id=`grep localid creds`
	id=${id:43}
	id=`echo $id | rev`
	id=${id:2}
	id=`echo $id | rev`
	ratelmt
	curl $curlargs -sA "$htmlagent" -d "localid=$id&region_name=$scramregion&move_region=1" --cookie "pin=$pin" https://www.nationstates.net/page=change_region | grep "is now located in" &>/dev/null && echo "$name passed" || retry
}
IFS=$'\n'
for i in `cat $nationlog`; do
	name=`awk '{print $1}' <<< $i`
	password=`awk '{print $2}' <<< $i`
	go
done
