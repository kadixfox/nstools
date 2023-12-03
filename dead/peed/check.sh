#!/bin/bash

check(){
	IFS=$oIFS
	i=($i)
	sleep 0.6
	echo "Checking '${i[0]}'"
	curl -sA "REDACTED" https://www.nationstates.net/cgi-bin/api.cgi -d "nation=${i[0]}&q=region" | grep "A Better Name Than That" || stop
}

stop(){
	echo "Check for '${i[0]}' failed, stopping"
	echo
	exit
}

oIFS=$IFS
IFS=$'\n'
for i in `cat nationlog`; do
	check
done
