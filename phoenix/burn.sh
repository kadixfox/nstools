#!/bin/bash

## NATIONSTATES V BABYFUR!?!??!?!?!!!!?!?!?!!??11??!?
## are we on part 3 now? part 4? i lost track >w<
##
## the game of cat and mouse; a game that never ends
## 
## -= kadix =-
##
## Dec 2 2023, 23:03 MST

nation="testlandia"

password="Password123"

agent="really cool browser useragent"

apiagent="really cool api useragent"

update(){
	sleep 1

	issues=`curl -sA "$agent" -H "X-Pin: $pin" "https://www.nationstates.net/cgi-bin/api.cgi?nation=$nation&q=issues"`
	count=`xmllint - --xpath "count(//ISSUE)" <<< $issues`
}

echo "nation: $nation"
echo "agent: $agent"
echo "apiagent: $apiagent"

sleep 8

pin=`curl -sA "$agent" -d "logging_in=1&nation=$nation&password=$password&submit=Login" -c - https://www.nationstates.net/ | tail -n1 | awk '$1=="#HttpOnly_.nationstates.net"{print $7}'`

echo "pin: $pin"

sleep 8

update

while [[ $count != 0 ]]; do
	echo "issues: $issues"

	echo "number of issues: $count"

	issue=`xmllint - --xpath "string(//ISSUE[$count]/@id)" <<< $issues`

	echo "issue: $issue"

	sleep 8

	token=$(echo `curl -sA "$agent" --cookie "pin=$pin" "https://www.nationstates.net/page=show_dilemma/dilemma=$issue" | grep "asform_token" | head -n1 | cut -c 6- | rev | cut -c 8- | rev`"</input>" | xmllint - --xpath "string(/input/@value)")

	echo "token: $token"

	sleep 8

	curl -sA "$agent" -d "nation=$nation&id=$issue&kind=enact&choice-0=1&asform_token=$token" --cookie "pin=$pin" "https://www.nationstates.net/page=enact_dilemma/dilemma=$issue" > /dev/null && echo "answered: $issue"
	
	update
done
