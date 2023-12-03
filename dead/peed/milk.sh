#!/bin/bash

agent="Mozilla/5.0 (X11; Linux x86_64; rv:120.0) Gecko/20100101 Firefox/120.0"

altifs(){
	IFS=$oIFS
}

ifs(){
	oIFS=$IFS
	IFS=$'\n'
}

issue(){
	count=`echo $issues | xmllint - --xpath "count(//ISSUE)"`
	if [[ $count != 0 ]]; then
		for ((h=1; h<=$count; h++)); do
			echo $issues | xmllint - --xpath "string(//ISSUE[$h]/@id)"
		done
	else
		altifs
		echo "No issues for '${i[0]}'"
	fi
}

login(){
	pin=`curl -sA "$agent" -d "logging_in=1&nation=${i[0]}&password=${i[1]}&submit=Login" -c - https://www.nationstates.net/ | tail -n 1 | awk '$1=="#HttpOnly_.nationstates.net"{print $7}'`
}

answer(){
	curl -sA "$agent" -d "choice-0=1" --cookie "pin=$pin" https://www.nationstates.net/page=enact_dilemma/dilemma=$issue > /dev/null && echo "Answered issue '$issue' for '${i[0]}"
}

ifs
for i in `cat nationlog`; do
	altifs
	i=($i)
	issues=`curl -sA "REDACTED" -H "X-Password: ${i[1]}" "https://www.nationstates.net/cgi-bin/api.cgi?nation=${i[0]}&q=issues"`
	login
	ifs
        for issue in `issue`; do
		issue
		answer
	done
done
