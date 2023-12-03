#!/bin/bash

login(){
	IFS=$oIFS
	i=($i)
	sleep 0.6
	curl -sA "REDACTED" -H "X-Password: ${i[1]}" https://www.nationstates.net/cgi-bin/api.cgi -d "nation=${i[0]}&c=ping" | grep -q "</NATION>" && loginok || retry
}

loginok(){
	echo "Logged into '${i[0]}'"
}

retry(){
	echo "Login to '${i[0]}' failed, trying again with longer delay"
	echo
	sleep 2
	login
}

oIFS=$IFS
IFS=$'\n'
for i in `cat nationlog`; do
	login
done
