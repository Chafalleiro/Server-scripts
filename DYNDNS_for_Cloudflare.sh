#!/bin/bash
### Cloudflare provides a complex and complete API to use its services. This script if to use Dynamic DNS in the DNS zones provided.
### Just add it to a CRON job and update at the intervals you want.
### It took 10.000 trained monkeys bashing keyboards along eight hundred hours to create thes script.
### Alfonso Abelenda was the monkey trainer at the Miskatonic University, now he is comfortably retired in Arkham Asylum.

#Tested in Debian 10
####################################################
#This script uses jq, a portable multiplatform JSON query helper for the commandline
#You can install it via package manager, pe "apt install jq" or by downloading it at the official site
#https://stedolan.github.io/jq/
####################################################

####################################################
#Edit this as needed
DEFAULT_DIR="/var/log/DynDNS_API/"
LOGFILE="$DEFAULT_DIR""Cloudflare_dyn.log"
IP4FILE="$DEFAULT_DIR""ip.txt"
IP6FILE="$DEFAULT_DIR""ip6.txt"
APIURL="https://api.cloudflare.com/client/v4"
EMAIL="YOUR_EMAIL_HERE"
API="YOUR_API_KEY"
# List the domains you neeed to update
DOMAINS=( "domain1.tld1" "domain2.tld2" "sub3.domain3.tld3" )
####################################################
IP4SW=0
IP6SW=0
#Get datetime
now=`date +"%Y-%m-%d %H:%M:%S"`
# Resolve current public IP, define working files
IP4=$( curl -s http://v4.ipv6-test.com/api/myip.php )
IP6=$( curl -s http://v6.ipv6-test.com/api/myip.php )
#Check if working files exist, if not create them. If IP file exists, pass value to var and update IP.
if [ -f "$LOGFILE" ]; then
    IP4ANT=$(cat "$IP4FILE")
    echo ${IP4} > "$IP4FILE"
    IP6ANT=$(cat "$IP6FILE")
    echo ${IP6} > "$IP6FILE"
else
    echo "No IP files found, creating..."
	mkdir "$DEFAULT_DIR"
	IP4ANT="$IP4"
	IP6ANT="$IP6"
    echo ${IP4ANT} >> "$IP4FILE"
    echo ${IP6ANT} >> "$IP6FILE"
    echo {$now} "Created 1984 log and IP files" >> "$LOGFILE"
fi
if [ "$IP4" != "$IP4ANT" ]; then
	IP4SW=1
fi
if [ "$IP6" != "$IP6ANT" ]; then
	IP6SW=1
fi

#We get the zones data and dump into a file. We get 25 results per page, can be configured to get more
#using the results parameter.
curl -s -X GET "$APIURL/zones?per_page=25" -H "X-Auth-Email: $EMAIL" -H "X-Auth-Key: $API" -H "Content-Type: application/json" | jq '.' > cloud_zones.json
#We search the domains listed in the config array above into the dumped zones and make an array of zones to be updated.
ZONES=$( jq .result_info.total_count cloud_zones.json )
#Array to store Zone Ids
declare -a ZONESARR
for (( i=0; i<$ZONES; i++ ))
do  
	for j in "${DOMAINS[@]}"
	do
		:		
		if [[ $j == $( jq -r .result[$i].name cloud_zones.json ) ]]; then
			#Check the manual for the use of -r parameter
			ZONESARR+=( $( jq -r .result[$i].id cloud_zones.json ) )
		fi
	done
done

#First we dump the records of each zone in separate files, the code can get messy and calling the API is slower than reading the data from disk.
#Array with the number of records per zone
RECv4_CNT=0
RECv6_CNT=0
for zoneid in "${ZONESARR[@]}"
	do
	:
	RECv4_CNT=0
	RECv6_CNT=0
		curl -s -X GET "$APIURL/zones/$zoneid/dns_records/" -H "X-Auth-Email: $EMAIL" -H "X-Auth-Key: $API" -H "Content-Type: application/json" | jq  '.' > cloud_$zoneid\_recs.json
		for (( i=0; i<$( jq -r .result_info.total_count cloud_$zoneid\_recs.json ); i++ ))
			do
			#IPV4
				if [ $IP4SW = 1 ]; then
					if [ $( jq -r .result[$i].type cloud_$zoneid\_recs.json ) = "A" ]; then
						#We update the A record found in the zones
						#The command line gets tricky here, read the last line quotes carefully
						curl -s -X PUT "$APIURL/zones/$zoneid/dns_records/$( jq -r .result[$i].id cloud_$zoneid\_recs.json )"\
						 -H "X-Auth-Email: $EMAIL"\
						 -H "X-Auth-Key: $API"\
						 -H "Content-Type: application/json"\
						 --data '{"type":"A","name":'$( jq .result[$i].name cloud_$zoneid\_recs.json )',"content":"'$IP4'","ttl":120,"proxied":true}' | jq '.' > "$DEFAULT_DIR"update_result.json
						 
						if [ $( jq -r .success update_result.json ) = "false" ]; then
							echo {$now}"There was an error updating IPv4 check updates_result.json to know more."  >> $LOGFILE
							cat update_result.json >> "$DEFAULT_DIR"updates_result.json
						else
							let RECv4_CNT++
							echo {$now}"Updated IPv4 in " $( jq .result[$i].name cloud_$zoneid\_recs.json ) >> $LOGFILE
							cat update_result.json >> "$DEFAULT_DIR"updates_result.json
						fi
					fi
				fi
			#IPV6
				if [ $IP6SW = 1 ]; then
					if [ $( jq -r .result[$i].type cloud_$zoneid\_recs.json ) = "AAAA" ]; then
						#We update the found AAAA records in the zones
						#The code gets tricky here, read the last line quotes carefully
						curl -s -X PUT "$APIURL/zones/$zoneid/dns_records/$( jq -r .result[$i].id cloud_$zoneid\_recs.json )"\
						 -H "X-Auth-Email: $EMAIL"\
						 -H "X-Auth-Key: $API"\
						 -H "Content-Type: application/json"\
						 --data '{"type":"AAAA","name":'$( jq .result[$i].name cloud_$zoneid\_recs.json )',"content":"'$IP6'","ttl":120,"proxied":true}' | jq '.' >> "$DEFAULT_DIR"update_result.json
						 
						if [ $( jq -r .success update_result.json ) = "false" ]; then
							echo {$now}"There was an error updating IPv6 check updates_result.json to know more."  >> $LOGFILE
							cat update_result.json >> "$DEFAULT_DIR"updates_result.json
						else
							let RECv6_CNT++
							echo {$now}"Updated IPv6 in " $( jq .result[$i].name cloud_$zoneid\_recs.json ) >> $LOGFILE
							cat update_result.json >> "$DEFAULT_DIR"updates_result.json
						fi
					fi
				fi
			done
		echo {$now}"Changed " $RECv4_CNT " IPv4 records in zone " $zoneid >> $LOGFILE
		echo {$now}"Changed " $RECv6_CNT " IPv6 records in zone " $zoneid >> $LOGFILE
	done

#Maybe Perl or C would be a more sensible way to do this stuff and a fine way to add some UI and deal with persistent data.
#I did just because I started to write a simple script that got a bit complicated and needed to finish it. Fortuntelly is shorter and simpler than my first idea.
