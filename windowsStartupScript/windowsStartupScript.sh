#!/bin/sh

# Author: Jonathan Oh
# Location: SILC LSS
# Date: 07/28/2021
# Description: This script will create a dialogue box for selecting between two different boot volumes.
#				Since we have issues with BootRunner + NoLoAD, we'll use this solution for the moment.

# Creates the actual dialogue box and the user's selection is piped into /dev/null
/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -icon /usr/local/LSS_SETUP/Scripts/windowsStartupScript/windows10.icns -windowType hud -description "Would you like to use Windows? MacOS will automatically boot in 15 seconds." -alignDescription left -button1 "No" -button2 "Yes" -cancelButton 1 -timeout 15 -defaultButton 1 -cancelButton 1 &> /dev/null

# From /dev/null we'll grab the output and compare it, if they pressed button two then..
if [ $? == 2 ]; then
	# Mount BOOTCAMP for only one single reboot using the nextonly flag
	sudo bless --device /dev/disk0s1  --setBoot --nextonly --verbose
	# Reboot the machine to stage Windows
	sudo reboot
fi