#!/bin/bash
. config.sh
retry(){
        echo "$name failed, trying again"
        go
}
go(){
        echo "running for $name"
        sleep $chewrl
        curl $curlargs -sA $apiagent -H "X-Password: $password" -d "nation=$name&c=ping" https://www.nationstates.net/cgi-bin/api.cgi | grep "</NATION>" &>/dev/null && echo "$name passed" || retry
}
IFS=$'\n'
for log in `cat $nationlog`; do
        name=`cut -d " " -f1 <<<$log`
        password=`cut -d " " -f2 <<<$log`
        go
done
