#!/bin/bash

# Author: Jonathan Oh
# Location: SILC LSS
# Date: 06/14/2021
# Description: This script will run at every login and will copy HIToolbox for languages

# Get the current logged in user's full name
USER=`stat -f%Su /dev/console`

#The actual HIToolbox plist that we want copied to all users
find Users/*/Library/Preferences -maxdepth 0 -exec cp /usr/local/LSS_SETUP/Preferences/com.apple.HIToolbox.plist {} \;

find Users/*/Library/Preferences -maxdepth 0 -exec cp /usr/local/LSS_SETUP/Preferences/com.apple.systemuiserver.plist {} \;

#The actual HIToolbox plist that we want copied to all users
#cp /usr/local/LSS_SETUP/Preferences/com.apple.HIToolbox.plist /Users/$USER/Library/Preferences/

#cp /usr/local/LSS_SETUP/Preferences/com.apple.systemuiserver.plist /Users/$USER/Library/Preferences/

killall SystemUIServer
