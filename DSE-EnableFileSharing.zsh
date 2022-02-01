#!/bin/zsh

# Author: Andrew W. Johnson
# Date: 2020
# Version 1.00
# Organization: Stony Brook University/DoIT
#
# This Jamf script will turn on SMB file sharing.
# 

	# Check to see if SMB is turned on. 
isSMB=$( /bin/launchctl list | egrep -ic smbd )
if [ ${isSMB} -eq 1 ]; then
	/bin/echo "SMB is already running."
	/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename "${0}" )[$$]: SMB is already running."  >> /var/log/jamf.log
else
		# If not turn it on.
	/bin/echo "SMB is not running. Will attempt to start it..."
	/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename "${0}" )[$$]: SMB is not running. Will attempt to start it..."  >> /var/log/jamf.log
	/bin/launchctl load -w /System/Library/LaunchDaemons/com.apple.smbd.plist
	/usr/bin/defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server.plist EnabledServices -array disk

		# Check to see if it started.
	isSMB=$( /bin/launchctl list | egrep -ic smbd )
		if [ ${isSMB} -eq 1 ]; then
			/bin/echo "SMB has started successfully."
			/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename "${0}" )[$$]: SMB has started successfully."  >> /var/log/jamf.log
		else
			/bin/echo "SMB failt to start..."
			/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename "${0}" )[$$]: SMB failt to start..."  >> /var/log/jamf.log
		fi
fi

exit 0
