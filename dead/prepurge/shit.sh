#!/bin/bash
agent="NCSA_Mosaic/5.0 (X11;Plan 9 4.0)"
name="Chinese+Civilian+Weather+Balloon+"
password="mexicanmcflurry"
region="chinese_civilian_weather_balloons"
for i in {0..256}; do
	echo "logging in to $i"
	sleep 2
	pin=`curl -sA "$agent" -d "logging_in=1&nation=$name$i&password=$password&submit=Login" -c - https://www.nationstates.net/region=$region | tee damn | tail -n1 | awk '$1=="#HttpOnly_.nationstates.net"{print $7}'`
	id=`grep localid damn`
	id=${id:43}
	id=`echo $id | rev`
	id=${id:2}
	id=`echo $id | rev`
	#sleep `echo -e "import random\nprint(4+random.randrange(1,4,1))" | python3`
	echo "moving $i"
	sleep 2
	curl -sA "$agent" -d "localid=$id&region_name=$region&move_region=1" --cookie "pin=$pin" https://www.nationstates.net/page=change_region > /dev/null
	#sleep `echo -e "import random\nprint(4+random.randrange(1,4,1))" | python3`
done
