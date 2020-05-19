# **=== Server scripts ===**

## == Description ==

Scripts to help run a home based webserver.

 DYNDNS_by_API.sh uses curl to get the external ip (ipv4) of the host, uses a temp file "ip.txt" to check if changed, if so it sends the new one to a DNS host that uses an API to make the changes.

When my system has disconnections, the router doesn't reestablish the ipv6 addresses that I use, restarting the network manager solves the problem, ststus.sh automatizes the check of the networking status and restarts the service if needed using a text file to check if there were connections problems.


### Usage
Copy the files in a directory that suits you, edit the Files to match your desired route to the logs outputted by the scripts.
You can also use cron to schedule the execution. The fields that you need to edit would be:

### DYNDNS_by_API.sh

- DEFAULT_DIR="**/var/log/DynDNS_API/**"  - Put here the path to your log directory

- LOGFILE="$DEFAULT_DIR""**1984_dyn.log**" - The name of the log file

- IPFILE="$DEFAULT_DIR""**ip.txt**" - The name of the check IP file

- APIURL="https://api.1984.is/1.0/freedns/?apikey=" - Copy here the start of the code provided by your DNS server provider. This is a generic generic example by 1984 hosting.

- API="**YOUR_API_KEY**" - Important, the API key that your DNS server provided you

- DOMAINS=( "**domain1.tld1" "domain2.tld2" "sub3.domain3.tld3**" ) - A list of domains and subdomains that uses the IP that you are renewing.

  

### status.sh

- DEFAULT_DIR="/var/log/NWStatus/"   - Put here the path to your log directory
- LOGFILE="$DEFAULT_DIR""status.log" -  The name of the log file
- STATUSFILE="$DEFAULT_DIR""ststus.txt" - The name of the check network status file

## == Installation ==

Download and extract the files in a directory that suits you. Use chown user:user and chmod 660 to make them usable by the user you want.

For the "status.sh" The user you select must have permissions to  use nmcli and systemctl, and write for the directory where you want to write the log of its operations.

For "DYNDNS_by_API.sh" the user must have permissions to use "curl", and write the directory selected for its logs.

#### == Changelog ==

= 1.0.0 =

Release.

#### == Files explanation ==

* DYNDNS_by_API.sh Script that check own IP, creates and uses a log file and a ip file.
* status.sh Script that check conectivity, creates and uses a log file and a status of the connection file.

