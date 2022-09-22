#!/bin/bash
#==============================================================================================================
#					Build Script #1
#==============================================================================================================
# Author: Brayan Molina
# Date:	  July 31 2022
# Description: Demonstrates ability to create a software management script. This script
# will update the server weekly on Fridays at 11pm.
#==============================================================================================================
#==============================================================================================================
# 					TO RUN THIS SCRIPT:
# 1. CRONTAB SETTINGS:0 23 * * 5 root /home/brayan/bin/buildscript1.sh
# 2. User needs to be changed in crontab settings & last line of script to reflect "tsand" home directory
#==============================================================================================================


#Verification of superuser:
if [ $UID != 0 ];
then
	echo "You need to be a superuser!"
fi

# Allows superuser to update server. All updated values are stored in variable $update.
# The command date is broken into month_day_year and stored in variable $scriptdate.
# Values stored in $update is placed in a file labeled weeklyupdates_scripdate, where scripdate is the date the script ran.
# Final file is stored in user's desktop directory.

if [ $UID == 0 ];
then
	update=$(sudo apt update)
	scriptdate=$(echo "$(date)" | awk -F " " '{print $2 "_" $3 "_" $7}')
	echo "$update" >> /home/brayan/Desktop/weeklyupdates_"$scriptdate".txt
fi
exit 0
