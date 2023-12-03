#!/bin/bash
#source ./nations.sh
agent="Mozilla/5.0 (Nintendo Wii; U; ; 3642; en) AppleWebKit/601.1 (KHTML, like Gecko) Tesla QtCarBrowser PaleMoon/27.1.2"
name="acc+node+"
password="REDACTED"
region="europeasant_union"
for i in {0..128}; do
	pin=`curl -sA "$agent" -d "logging_in=1&nation=$name$i&password=$password&submit=Login" -c - "https://www.nationstates.net/region=bits" | tee damn | tail -n1 | awk '$1=="#HttpOnly_.nationstates.net"{print $7}'`
	id=`grep localid damn`
	id=${id:43}
	id=`echo $id | rev`
	id=${id:2}
	id=`echo $id | rev`
	sleep `echo -e "import random\nprint(4+random.randrange(1,4,1))" | python3`
	curl -sA "$agent" -d "convertproduction=shield%3A4" --cookie "pin=$pin" "https://www.nationstates.net/nation=$name$i/page=nukes/view=production"
	sleep `echo -e "import random\nprint(4+random.randrange(1,4,1))" | python3`
done
