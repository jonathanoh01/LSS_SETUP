#!/bin/sh

# Author: Jonathan Oh
# Location: SILC LSS
# Date: 06/14/2021
# Description: This launchAgent script will handle ensuring that any processes that need to be run during
#				login are properly setup.

# Get the current user's name and check if it's any of our local accounts
USER=`stat -f%Su /dev/console`

# We don't want any of these commands to run for our local accounts, so we need to check if it's a network user
if [ $USER != "silclss" ]
then
	if [ $USER != "silc" ]
	then
		if [ $USER != "silclsstsa" ]
		then
			if [ $USER != "ACTSPEexam" ]
			then
				if [ $USER != "exammanager" ]
				then
				
					# If it's not a local user then we'll open PCClient.app
					open /Applications/PCClient.app
			
					# We'll then go ahead and configure Citrix to allow a faster login process
					cp -r /usr/local/LSS_SETUP/Preferences/Citrix\ Files/ /Users/$USER/Library/Application\ Support
			
					# Restart Citrix Workspace to allow changes to occur
					launchctl unload /Library/LaunchAgents/com.citrix.AuthManager_Mac.plist
					launchctl load /Library/LaunchAgents/com.citrix.AuthManager_Mac.plist
					launchctl unload /Library/LaunchAgents/com.citrix.ReceiverHelper.plist
					launchctl load /Library/LaunchAgents/com.citrix.ReceiverHelper.plist
			
				fi
			fi
		fi
	fi
fi
