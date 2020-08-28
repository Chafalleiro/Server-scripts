#!/bin/bash

### Several Dynamic DNS providers have an API o update the IP by USR/PWD, this script is meant to make the update easier and log it.
### This is configured for Dynu
### Just add it to a CRON job and update at the intervals you want.
### It took 10.000 trained monkeys bashing keyboards along eight hundred hours to create thes script.
### Alfonso Abelenda was the monkey trainer at the Miskatonic University, now he is comfortably retired in Arkham Asylum.
#Tested in Debian 10
####################################################
#Edit this as needed
DEFAULT_DIR="/var/log/DynDNS_API/"
LOGFILE="$DEFAULT_DIR""Dynu_dyn.log"
IPFILE="$DEFAULT_DIR""ip.txt"
APIURL="https://api.dynu.com/nic/update?"
USER="USERNAME"
PASSWORD="PASSWORD"
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
#Transform the PASSWORD into an SHA5212 hash
VAR=$( echo -n  $PASSWORD | openssl dgst -sha512 )
PASSWORD=$( echo $VAR | sed s/\(stdin\)\=\ // )

#Check if the gotten ip is valid
TEST=$( echo $IP | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | wc -w )
if [ "$TEST" = "1" ]; then
        echo ${IP} > "$IPFILE"
        #Check if the address changed
        if [ "$IP" != "$IPANT" ]; then
                #Update DNS Records.
				URL="$APIURL&username=$USER&myip=${IP}&password=$PASSWORD"
				exit=$( curl -s $URL )
				echo {$now} "$exit"  >> "$LOGFILE"
        else
                echo {$now} "ip Address $IP unchanged" >> "$LOGFILE"
        fi
else
        echo {$now} "Invalid IP, Network problem, logging. IP got is: $IP"  >> "$LOGFILE"
        #If we use some sort of network monitor, code could go here
fi
#END of script
