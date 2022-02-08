#!/bin/sh

# Author: Jonathan Oh
# Location: SILC LSS
# Date: 06/14/2021
# Description: This script will configure the network aspect of each machine and will
#				use MAC Addresses as a point of reference.

#The array MAC holds all the known MAC addresses of 65 and 61, we will compare the 
	#current Mac's MAC address to this array through a loop
MAC=(
14:98:77:54:33:cc)

 
NAMES=(
DH132Amacm01)
 
#CURRENTMAC is a variable that stores the current Mac's MAC address
CURRENTMACSTRING=`ifconfig en0 | awk '/ether/{print $2}'`

#From the index values of 0 to 58 (the total amount of IP's and MAC addresses we have)
	#We are going to search the arrays for a matching MAC address
for i in {0..62}
do
	#MACCARRAYSTRING will hold the String literal of the MAC Address at index "$i"
	MACARRAYSTRING="${MAC[i]}"

	#If there happens to be a match between the two MAC addresses, then...
	if [ "$CURRENTMACSTRING" == "$MACARRAYSTRING" ]
	then
		#We will print out the MAC addresses and corresponding information just for reference.
		echo "\nCurrent machine's MAC: $CURRENTMACSTRING"
		echo "Matched MAC: $MACARRAYSTRING"
		echo "Index at: $i"
		echo "Matched Machine Name: ${NAMES[i]}\n"
		
		GETNAME=${NAMES[i]}
		
		#Add a pause for any pending commands that need to be completed.
		sleep 5
		
		#Set the machine's name with the name from the same index
		scutil --set ComputerName $GETNAME
		scutil --set LocalHostName $GETNAME
		scutil --set HostName $GETNAME
		
	fi
done

# This command will reconnect back to our SILC Jamf Site and update the machine's name and IP on our end.
sudo jamf recon

exit 0



