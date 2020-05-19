### Check network status, log it and restart it after losing conectivity.
### It took 10.000 trained monkeys bashing keyboards along eight hundred hours to create thes script.
### Alfonso Abelenda was the monkey trainer at the Miskatonic University, now he is comfortably retired in Arkham Asylum.

####################################################
#Edit this as needed
DEFAULT_DIR="/var/log/NWStatus/"
LOGFILE="$DEFAULT_DIR""status.log"
STATUSFILE="$DEFAULT_DIR""status.txt"
####################################################

STATUS=$(nmcli networking connectivity)
now=`date +"%Y-%m-%d %H:%M:%S"`

if [ -f "$LOGFILE" ]; then
    STANT=$(cat "$STATUSFILE")
else
    echo "No NWSstatus files found, creating..."
    mkdir "$DEFAULT_DIR"
    STANT="full"
    echo {$now} "Created NWStatus log files" >> "$LOGFILE"
    echo "full" >> "$STATUSFILE"
fi

if [ "full" = "$STATUS" ]; then
    echo ${now} "Full connection." >> "$LOGFILE"
    if [ $STANT != "full" ]; then
        echo $STATUS > "$STATUSFILE"
        echo ${now} " Launched NetworkManager restart" >> "$LOGFILE"
        systemctl restart NetworkManager.service
        echo ${now} "NetworkManager restarted" >> "$LOGFILE"
    fi
else
    echo ${now} ${STATUS} >> "$LOGFILE"
    echo $STATUS > "$STATUSFILE"
fi
#END of script