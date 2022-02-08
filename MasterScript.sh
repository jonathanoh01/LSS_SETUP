#!/bin/sh

# Author: Jonathan Oh
# Location: SILC LSS
# Date: 06/14/2021
# Description: This master script will run other scripts and also setup other aspects of the machine

set +e

# Set the current directory to our LSS_SETUP scripts folder
cd /usr/local/LSS_SETUP/Scripts/

# Run our scripts in succession with delays in between to ensure that each script is being run properly
sh ipConfigScript.sh
sleep 5

sh disableWordScreen.sh
sleep 5

sh HIToolbox_Install_Script.sh
sleep 5

# Configure ARD to allow remote access using the silclss account
/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -allowAccessFor -specifiedUsers
/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -users silclss -access -on -privs -all

# Configure the lockscreen to allow network users to login
cp /usr/local/LSS_SETUP/Preferences/screensaver /etc/pam.d/
/usr/bin/defaults write /Library/Preferences/com.apple.loginwindow StartupDelay -int 60

# Disable Wi-Fi, we'll be using Ethernet instead
networksetup -setnetworkserviceenabled Wi-Fi Off

# Allow access to our ACTSPE exam 
spctl --master-disable

# Copies our custom launchAgent that will configure Citrix and open PCClient on login
cp /usr/local/LSS_SETUP/Preferences/com.silc.login.plist /Library/LaunchAgents/

# Set the permissions for Patchwork Girl and PCClient
chmod -R 755 /Applications/Patchwork\ Girl
chown -R root:wheel /Applications/Patchwork\ Girl
/Applications/PCClient.app/Contents/Resources/set-permissions.command

# Remove Microsoft Auto Update, this prevents users from getting annoying pop-ups
rm -Rf /Library/Application\ Support/Microsoft/MAU2.0

# Remove Antidote 9 launch agent, this prevents Antidote opening for non-french users
rm -Rf /Applications/Antidote 9.app/Contents/Library/LoginItems/AgentAntidote.app

# Copy the preferences for NoLoAD so it's setup for our liking
cp -Rf /usr/local/LSS_SETUP/Preferences/NoLoAD/* /Library/Preferences/

# To ensure no login/startup hooks have been disturbed, we'll use jamf manage to reinitiate all hooks
jamf manage

exit 0