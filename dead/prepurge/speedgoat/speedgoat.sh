#!/bin/bash
. config.sh
ratelmt(){
	if [ $addrandomrl == "true" ]; then
		sleep $(($speedgoatrl + RANDOM % $speedgoatrandrlrange))
	else
		sleep $speedgoatrl
	fi
}
ajax2a(){
        curl $curlargs -sA $htmlagent https://www.nationstates.net/page=ajax2/a=$1
}
retry(){
        echo "$name failed, trying again"
        go
}
go(){
	ratelmt
        curl $curlargs -sA "$htmlagent" -d "name=$name&type=$type&flag=$flag.svg&currency=$currency&animal=$animal&slogan=$slogan&password=$speedgoatpassword&confirm_password=$speedgoatpassword&legal=1&style=$style" https://www.nationstates.net/cgi-bin/build_nation.cgi | grep "check=1" && retry || echo "$name passed"
}
while true; do
        IFS=,
        for name in `ajax2a genrandomnames`; do
                if [ `ajax2a checknationname/name=$name` == '<p class="info">Available! This name may be used to found a new nation.</p>' ]; then
                        type=`shuf -i 100-138 -n1`
                        IFS=^
                        flag=`for i in $flags; do echo $i; done | shuf | head -n1`
                        currency=`for i in $currencies; do echo $i; done | shuf | head -n1`
                        animal=`for i in $animals; do echo $i; done | shuf | head -n1`
                        slogan=`for i in $slogans; do echo $i; done | shuf | head -n1`
                        style="`shuf -i 0-100 -n1`.`shuf -i 0-100 -n1`.`shuf -i 0-100 -n1`"
                        echo "running for $name"
                        go
                        echo "`sed -e \"s/ /_/g\" <<<$name | tr '[:upper:]' '[:lower:]'` $speedgoatpassword" >> $nationlog
                else
                        echo "will not run for $name"
                fi

        done
done
