#!/bin/bash
agent="Mozilla/5.0 (Linux; U; Android 4.0.4; en-us; Glass 1 Build/IMM76L; XE7) AppleWebKit/601.1 (KHTML, like Gecko) Tesla QtCarBrowser Safari/601.1"
name="Chinese+Civilian+Weather+Balloon+"
## you can make this whatever nation type; there's a bunch; look into it :3
type="124"
## also many flag types
flag="China.svg"
currency="US Inte- I Mean Weather Data"
animal="Weather Balloon"
slogan="Dont mind us, just spying- err- studying the atmosphere"
password="mexicanmcflurry"
## style can be anything from 0.0.0 to like 99.99.99, lower being more freedom, higher being less
style="0.0.0"
retry(){
	echo "$i failed, trying again"
	run
}
run(){
	## yeah turns out this doesnt really help us much and we can do this without python anyway
	#sleep `echo -e "import random\nprint(128+random.randrange(1,32,1))" | python3`
	sleep 240
	curl -sA "$agent" -d "name=$name$i&type=$type&flag=$flag&currency=$currency&animal=$animal&slogan=$slogan&password=$password&confirm_password=$password&legal=1&style=$style" https://www.nationstates.net/cgi-bin/build_nation.cgi | grep "check=1" && retry || echo "$i passed"
}
for i in {244..256}; do
	echo "Running for $i"
	run
done
