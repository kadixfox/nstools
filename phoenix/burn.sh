#!/bin/bash

## NATIONSTATES V BABYFUR!?!??!?!?!!!!?!?!?!!??11??!?
## are we on part 3 now? part 4? i lost track >w<
##
## the game of cat and mouse; a game that never ends
## 
## -= kadix =-
##
## burn.sh - answer issues via html site
##
## Dec 2 2023, 23:56 MST

nation="testlandia"

password="Password123"

agent="really cool browser useragent"

apiagent="really cool api useragent"

token="asform token"

echo "nation: $nation"
echo "agent: $agent"
echo "apiagent: $apiagent"

issues=`curl -sA "$apiagent" -H "X-Password: $password" "https://www.nationstates.net/cgi-bin/api.cgi?nation=$nation&q=issues"`

pin=`curl -sA "$agent" -d "logging_in=1&nation=$nation&password=$password&submit=Login" -c - https://www.nationstates.net/ | tail -n1 | awk '$1=="#HttpOnly_.nationstates.net"{print $7}'`

count=`xmllint - --xpath "count(//ISSUE)" <<< $issues`

echo "number of issues: $count:"

if [[ $count != 0 ]]; then
	for ((i=1; i<=$count; i++)); do
		issue=`xmllint - --xpath "string(//ISSUE[$i]/@id)" <<< $issues`
		curl -sA "$agent" -d "nation=$nation&id=$issue&kind=enact&choice-0=1&asform_token=$token" --cookie "pin=$pin" "https://www.nationstates.net/page=enact_dilemma/dilemma=$issue" > /dev/null && echo "answered: $issue"
		sleep 1
	done
fi
