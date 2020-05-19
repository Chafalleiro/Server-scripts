#!/bin/bash

### 1984 Domains provides an API to update a DNS, this script is meant to make the update easier and log it.
### Just add it to a CRON job and update at the intervals you want.
### It took 10.000 trained monkeys bashing keyboards along eight hundred hours to create thes script.
### Alfonso Abelenda was the monkey trainer at the Miskatonic University, now he is comfortably retired in Arkham Asylum.
#Tested in Debian 10

####################################################
#Edit this as needed
DEFAULT_DIR="/var/log/DynDNS_API/"
LOGFILE="$DEFAULT_DIR""1984_dyn.log"
IPFILE="$DEFAULT_DIR""ip.txt"
APIURL="https://api.1984.is/1.0/freedns/?apikey="
API="YOUR_API_KEY_HERE"
# List the domains you neeed to update
DOMAINS=( "domain1.tld" "mail.domain1.tld" "www.domain1.tld" "domain2.tld")
####################################################

#Get datetime
now=`date +"%Y-%m-%d %H:%M:%S"`

# Resolve current public IP, define working files
IP=$( curl -s ifconfig.me )

#Check if working files exist, if not create them. If IP file exists, pass value to var and update IP.
if [ -f "$LOGFILE" ]; then
    IPANT=$(cat "$IPFILE")
    echo ${IP} > "$IPFILE"
else
    echo "No IP files found, creating..."
	mkdir "$DEFAULT_DIR"
	IPANT="$IP"
    echo ${IPANT} >> "$IPFILE"
    echo {$now} "Created 1984 log and IP files" >> "$LOGFILE"
fi
#Check if the gotten ip is valid
TEST=$( echo $IP | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | wc -w )
if [ "$TEST" = "1" ]; then
        echo ${IP} > "$IPFILE"
        #Check if the address changed
        if [ "$IP" != "$IPANT" ]; then
                #Update 1984 DNS Records.
                for i in "${DOMAINS[@]}"
					do
						: 
						#URL="https://api.1984.is/1.0/freedns/?apikey=$API&domain=$i&ip=${IP}"
						URL="$APIURL$API&domain=$i&ip=${IP}"
						exit+=$( curl -s $URL )
					done
				echo {$now} "$exit"  >> "$LOGFILE"
        else
                echo {$now} "ip Address $IP unchanged" >> "$LOGFILE"
        fi
else
        echo {$now} "Invalid IP, Network problem, logging. IP got is: $IP"  >> "$LOGFILE"
        #If we use some sort of network monitor, code could go here
fi
#END of script
