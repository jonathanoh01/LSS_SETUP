#!/bin/sh

# Author: Jonathan Oh
# Location: SILC LSS
# Date: 06/21/2021
# Description: This script will wipe the users every day and clean up any leftover users to prevent build-up


# This will handle the loop and determine whether or not to end the loop
END="FALSE"
# Set an index for our array of users
index=0

# This is the command that will gather all logged in users, it will skip local accounts and other misc accounts
USERLIST=`dscl . -list /Users | grep -v _ | grep -v cas | grep -v daemon | grep -v nobody | grep -v root | grep -v silc | grep -v ACTSPEexam | grep -v silclss | grep -v exammanager`
# This will conver the list of names to an actual array
USERSARRAY=($USERLIST)

# Beginning of loop that will recurse through the list of users, end when we tell it to end
while [ $END == "FALSE" ]
do
	
	# This will basically just check if there are no users to clear, it will end the script	entirely
	if [ ${#USERSARRAY[@]} -eq 0 ]
	then
		exit 0
	fi
	
	# Start to delete the current index user using the dscl command. This doesn't clear the user's home folder
	sudo dscl . -delete "/Users/${USERSARRAY[$index]}"
	
	# Check if the directory of the index user exists, if it doesn't it won't attempt to delete a non-existent directory
	if [ -d "/Users/${USERSARRAY[$index]}" ]
	then
		# Recurse and remove current index user's home directory
		sudo rm -rf "/Users/${USERSARRAY[$index]}"
	fi
	
	########################################################################################################
	# This portion of the script is intended to determine whether we need to continue recursing or stopping the script
	########################################################################################################
	
	# Run the command again to gather the rest of users we need to wipe
	USERCHECK=`dscl . -list /Users | grep -v _ | grep -v cas | grep -v daemon | grep -v nobody | grep -v root | grep -v silc | grep -v ACTSPEexam`
	USERCHECKARR=($USERCHECK)
	
	# Check if there are any more users to clear, if not end the script
	if [ ${#USERCHECKARR[@]} -eq 0 ]
	then
	
		# This will terminate the loop
		END="TRUE"
		
	# Another case to end the script is when the length of the user array is equal to the current index
	elif [ ${#USERSARRAY[@]} -eq $index ]
	then
	
		# This will terminate the loop
		END="TRUE"

	fi

	# Increment index to allow us to continue recursing through array of users
	((index++))

# End the while loop	
done