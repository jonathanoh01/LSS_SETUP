#!/bin/bash

# Author: Jonathan Oh
# Location: SILC LSS
# Date: 1/12/2020
# Description: Displays/Writes the current machine's local name, IP address, and MAC address.

# The "$1" and "$2" variables are the parameters passed from the script input.
	# I added this so we can decide if we want to only display the network info,
	# or if we wanted to output the info into a file.
input=$1
networkPath=$2

# The initial commands ran to get the network info, these will be stored in a string variable
	# (the outputs of each command)
machineName=`scutil --get ComputerName`
ethMACAddress=`ifconfig en0 | awk '/ether/{print $2}'`
ethIPAddress=`ipconfig getifaddr en0`

# This is the complete machine information with new lines for outputting in a clean dialogue box.
completeAddresses="$machineName
$ethMACAddress 
$ethIPAddress"

# This is a tabbed version for outputting into a text file
completeAddressTab="$machineName	$ethMACAddress		$ethIPAddress"

# First I check to see if the user wants to output the data, and if so we need to make sure the 
	# user also provides a path to the file they want to write to.
if [ "$input" == "-w" ] || [ "$input" == "-a" ]
then
	# Check if there is a path or not
	if [[ "$2" == "" ]]
	then
		# Warn the user to enter a path to write to and provide a usage guide

		echo ""
		echo "Usage: ./displayMAC.sh [-o|-help]"
		echo "Usage: ./displayMAC.sh [-w|-a] [/pathTextFile/]"
		echo "-o: Outputs data in console. No writing will be performed."
		echo "-w: Writes to a text file and overwrites all data with the current machine information. Will create a .txt if none provided."
		echo "-a: Writes to a text file and appends all data with the current machine information. Will create a .txt if none provided."
		echo ""
		echo "Example: ./displayMAC.sh -a "/usr/local/ImageMojave/""
		echo "Example: ./displayMAC.sh -a "/usr/local/ImageMojave/file.txt""
		echo ""
		exit 0
	fi
fi

# If the user enter's a "-help" or doesn't enter anything at all then we'll provide a usage guide as well.
	# We'll also be running commands based off if the user provides a flag to output or write.
if [ "$input" == "-help" ] || [ $input == ""]
then
	echo ""
	echo "Usage: ./displayMAC.sh [-o|-help]"
	echo "Usage: ./displayMAC.sh [-w|-a] [/pathTextFile/]"
	echo "-o: Outputs data in console. No writing will be performed."
	echo "-w: Writes to a text file and overwrites all data with the current machine information. Will create a .txt if none provided."
	echo "-a: Writes to a text file and appends all data with the current machine information. Will create a .txt if none provided."
	echo ""
	echo "Example: ./displayMAC.sh -a "/usr/local/ImageMojave/""
	echo "Example: ./displayMAC.sh -a "/usr/local/ImageMojave/file.txt""
	echo ""
	exit 0

# If the input is -o then we'll be outputting the data into a dialogue box.
elif [[ "$input" == "-o" ]]
then
	# I used JAMF's provided dialogue box as it looks far cleaner than what I could make by hand. I have all the data listed as the main description
		# and added a JAMF provided network icon to make everything look clean and professional. The text box will automatically time out in
		# 1000 seconds which should be enough time for us to go around and check the information. It can also be closed with ESC.

	/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -icon /System/Library/PreferencePanes/Network.prefPane/Contents/Resources/Network.icns -windowType hud -title "Machine Info" -heading "Current Machine:" -description "$completeAddresses" -alignDescription left -button1 "OK" -cancelButton 1 -timeout 1000

# If the input is -w then we're overwriting our given file path.
elif [[ "$input" == "-w" ]]
then
	# Let the user know it's path to the file
	echo "Writing to: $networkPath"

	# Check whether the file exists, if not then we'll create an empty file with the "touch" command
	if [[ -f "$networkPath" ]]
	then
		echo "File exists, overwriting..."
	else
		echo "File does not exist, creating..."
		touch "$networkPath"
	fi
	
	# We can use the echo command with the ">" to pass through the data into our text file. 
		# This will overwrite the data in the file.
	echo $completeAddressTab > "$networkPath"
	
# If the input is -a then we're appending to our given file path.
elif [[ "$input" == "-a" ]]
then
	# Let the user know it's path to the file
	echo "Writing to: $networkPath"

	# Check whether the file exists, if not then we'll create an empty file with the "touch" command
	if [[ -f "$networkPath" ]]
	then
		echo "File exists, appending..."
	else
		echo "File does not exist, creating..."
		touch "$networkPath"
	fi

	# We can use the echo command with the ">>" to pass through the data into our text file. 
		# This will append the data in the file.
	echo $completeAddressTab >> "$networkPath"

# If the user somehow enters a flag that doesn't match any of these then we'll just display the usage guide.
else
	echo ""
	echo "Usage: ./displayMAC.sh [-o|-help]"
	echo "Usage: ./displayMAC.sh [-w|-a] [/pathTextFile/]"
	echo "-o: Outputs data in console. No writing will be performed."
	echo "-w: Writes to a text file and overwrites all data with the current machine information. Will create a .txt if none provided."
	echo "-a: Writes to a text file and appends all data with the current machine information. Will create a .txt if none provided."
	echo ""
	echo "Example: ./displayMAC.sh -a "/usr/local/ImageMojave/""
	echo "Example: ./displayMAC.sh -a "/usr/local/ImageMojave/file.txt""
	echo ""
	exit 0
fi