#!/bin/bash

# Jul 6 2023
# I never learn my lesson

flags="Aaland_Islands^Afghanistan^Albania^Alderney^Algeria^American_Samoa^Andalusia^Andorra^Angola^Anguilla^Antigua_and_Barbuda^Aragon^Argentina^Armenia^Aruba^Asturias^Austral_Islands^Australia^Austria^Azerbaijan^Azores^Bahamas^Bahrain^Balearic_Islands^Bangladesh^Barbados^Basque_Country^Belarus^Belgium^Belize^Benin^Bermuda^Bhutan^Bolivia^Bonaire^Bosnia_and_Herzegovina^Botswana^Brazil^British_Antarctic_Territory^British_Indian_Ocean_Territory^British_Virgin_Islands^Brunei^Bulgaria^Burkina_Faso^Burundi^Cambodia^Cameroon^Canada^Canary_Islands^Cantabria^Cape_Verde^Castile_and_Leon^Castilla-La_Mancha^Catalonia^Cayman_Islands^Central_African_Republic^Ceuta^Chad^Chile^China^Christmas_Island^Chuuk^Cocos_Islands^Colombia^Comoros^Cook_Islands^Costa_Rica^Cote_d'Ivoire^Croatia^Cuba^Curacao^Cyprus^Czech_Republic^Democratic_Republic_of_the_Congo^Denmark^Djibouti^Dominica^Dominican_Republic^East_Timor^Ecuador^Egypt^El_Salvador^England^Equatorial_Guinea^Eritrea^Estonia^Ethiopia^Europe^Extremadura^Falkland_Islands^Faroe_Islands^Federated_States_of_Micronesia^Fiji^Finland^France^French_Polynesia^Gabon^Galicia^Gambia^Gambier_Islands^Georgia^Germany^Ghana^Gibraltar^Greece^Greenland^Grenada^Guam^Guatemala^Guernsey^Guinea-Bissau^Guinea^Guyana^Haiti^Herm^Honduras^Hong_Kong^Hungary^Iceland^India^Indonesia^Iran^Iraq^Ireland^Isle_of_Man^Israel^Italy^Jamaica^Japan^Jersey^Jordan^Kazakhstan^Kenya^Kiribati^Kosovo^Kuwait^Kyrgyzstan^La_Rioja^Laos^Latvia^Lebanon^Lesotho^Liberia^Libya^Liechtenstein^Lithuania^Luxembourg^Macau^Madagascar^Madeira^Madrid^Malawi^Malaysia^Maldives^Mali^Malta^Marquesas_Islands^Marshall_Islands^Mauritania^Mauritius^Melilla^Mexico^Moldova^Monaco^Mongolia^Montenegro^Montserrat^Morocco^Mozambique^Murcia^Myanmar^Namibia^Nauru^Navarre^Nepal^Netherlands^New_Caledonia^New_Zealand^Nicaragua^Niger^Nigeria^Niue^Norfolk_Island^North_Korea^North_Macedonia^Northern_Mariana_Islands^Norway^Oman^Pakistan^Palau^Palestine^Panama^Papua_New_Guinea^Paraguay^People's_Republic_of_China^Peru^Philippines^Pitcairn_Islands^Poland^Portugal^Puerto_Rico^Qatar^Rapa_Nui^Republic_of_China^Republic_of_the_Congo^Romania^Russia^Rwanda^Saba^Saint-Pierre_and_Miquelon^Saint_Helena^Saint_Kitts_and_Nevis^Saint_Lucia^Saint_Vincent_and_the_Grenadines^Samoa^San_Marino^Sao_Tome_and_Principe^Sark^Saudi_Arabia^Scotland^Sealand^Senegal^Serbia^Seychelles^Sierra_Leone^Singapore^Sint_Eustatius^Sint_Maarten^Slovakia^Slovenia^Solomon_Islands^Somalia^South_Africa^South_Korea^South_Sudan^Sovereign_Military_Order_of_Malta^Spain^Sri_Lanka^Sudan^Suriname^Swaziland^Sweden^Switzerland^Syria^Taiwan^Tajikistan^Tanzania^Thailand^Tibet^Togo^Tokelau^Tonga^Trinidad_and_Tobago^Tristan_da_Cunha^Tuamotu_Archipelago^Tunisia^Turkey^Turkmenistan^Turks_and_Caicos_Islands^Tuvalu^Uganda^Ukraine^United_Arab_Emirates^United_Kingdom^United_States_Virgin_Islands^United_States_of_America^Uruguay^Uzbekistan^Valencian_Community^Vanuatu^Vatican_City^Venezuela^Vietnam^Wales^West_Papua^Yap^Yemen^Zambia^Zanzibar^Zimbabwe"
currencies="bitcoin^rupee^krona^dollar^ruble^baht^lira^mark^florin^peso^denier^guilder^franc^pound"
animals="emu^squirrel^penguin^cobra^horse^swan^leopard^turtle^dove^elephant^tiger^porpoise^sheep^parrot^eagle^wolf^lion^fox^giraffe^dolphin^unicorn^cow^falcon^beaver^kiwi^crocodile^bison^panther^kangaroo"
slogans="Strength Through Freedom^Might Makes Right^We Will Endure^Twirling Toward Freedom^Mission Accomplished^Justice, Piety, Loyalty^God, Homeland, Liberty^By The People For The People^Strength Through Compliance^Peace and Justice^Pride and Industry^Unity, Discipline, Work^You Can't Stop Progress^From Many, One"
agent="Mozilla/5.0 (Android 10; Mobile; rv:102.0) Gecko/102.0 Firefox/102.0"

ajax2a(){ sleep $(( 32 + `randgen 0 16` )) && curl -sA $agent https://www.nationstates.net/page=ajax2/a=$@;}

fieldshuf(){
	IFS=^ read -ra temp <<< $2
	size=${#temp[@]}
	index=$(($RANDOM % $size))
	export $1=${temp[$index]}
}

#randgen(){ shuf -i $1-$2 -n 1;}
## more posixy version
randgen(){ awk -v min=$1 -v max=$2 -v seed=$RANDOM 'BEGIN{srand(seed); print int(min+rand()*(max-min+1))}';}

longdelay(){ sleep $(( $1 + `randgen 0 128` ));}

buildnation(){
	longdelay 256
	curl -sA $agent https://www.nationstates.net/cgi-bin/build_nation.cgi -d "name=$randname&type=$type&flag=$flag.svg&currency=$currency&animal=$animal&slogan=$slogan&password=$password&confirm_password=$password&legal=1&style=$style" | grep "check=1" && retry || lognation
}

## Will cause segfault once Violet pulls out the banhammer
retry(){
	echo
	echo "Failed to create '$randname', trying again with a longer delay"
	longdelay 512
	buildnation
}

lognation(){
	echo "`sed -e \"s/ /_/g\" <<<$randname | tr "[:upper:]" "[:lower:]"` $password `curl -s ifconfig.me` `date "+%s %F-%H:%M:%S_%Z"`" >> nationlog
	echo
	echo "'$randname' created successfully"
	echo "----"
	echo
}

while true; do

	echo "Getting list of random names"
	echo
	IFS=,
	for randname in `ajax2a genrandomnames`; do
		
		echo "Checking if random name '$randname' is available"

		if [ `ajax2a checknationname -d name=$randname` == '<p class="info">Available! This name may be used to found a new nation.</p>' ]; then
	
			echo
			echo "Random name '$randname' is available"

			echo "Generating random nation type and stats"
			type=`randgen 100 138`
			style=`randgen 0 100`.`randgen 0 100`.`randgen 0 100`

			echo "Shuffling nation fields"
			IFS=
			fieldshuf flag $flags
			fieldshuf currency $currencies
			fieldshuf animal $animals
			fieldshuf slogan $slogans
			#password=`shuf -n 1 passwords`
			## whoever wrote awk is a fucking acid junkie
			password=`awk 'BEGIN{srand()}{a[NR]=$0}END{x=int(rand()*NR)+1; print a[x]}' passwords`
			
			echo
			echo "Creating nation with name '$randname' and configuration:"
			echo "Type: '$type'"
			echo "Stats: '$style'"
			echo "Flag: '$flag'"
			echo "Currency: '$currency'"
			echo "Animal: '$animal'"
			echo "Slogan: '$slogan'"
			echo "Password: '$password'"

			buildnation
		else
			echo
			echo "'$randname' not available"
		fi
	done
done
