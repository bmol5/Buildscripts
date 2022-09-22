#!/bin/bash
#==============================================================================================>
#                                       Build Script #3
#==============================================================================================>
# Author: Brayan Molina
# Date:   August 17th 2022
# Objective: Understand how to securely create accounts with limited access to resources
# meant for that user
#==============================================================================================>
#                                      Instructions:
# 1. Need to have autogit.sh file in order to fulfill objective of this buildscript.
# 2. Please be sure to run this script in the directory scripts are located.
#
# autogit.sh - can be used to automate adding,commiting and pushing to github
#=============================================================================================

#Will not create user if you are not superuser
if [[ $UID != 0 ]]
then
echo "Need to be a superuser!"
exit
fi

#if you are superuser then you are allowed to create user
if [[ $UID==0 ]];
then

#A shared folder will be made in the home directory and a group called GitAcc will be made
#The permissions of the shared folder will allow members of the GitAcc group to execute files

	sudo mkdir /home/sharedgitfiles
	sudo groupadd "GitAcc"
	sudo chgrp GitAcc /home/sharedgitfiles
	sudo chmod 770 /home/sharedgitfiles
	sudo chmod +s /home/sharedgitfiles

#The following commands copy the ncessary scripts for this project to the shared folder.
	scriptloc=$(find -name buildscript3.sh)
	cp "$scriptloc" /home/sharedgitfiles
	gitloc=$(find -name autogit.sh)
	cp "$gitloc" /home/sharedgitfiles

#Specifies first and last name of user being made. FInal username is first initial and last name.
	echo "Please specify the first name of the user to be added to GitAcc group"
	read fname
	fname2=$(echo "$fname" | cut -b1)
	echo "Please specify last name for this user"
	read lname
	fullname=$fname2$lname

#Prompts user to select if they would like to add user to the GitAcc group
	echo "=========="
	echo "$fullname"
	echo "=========="
	echo "Would you like to add this user to the GitAcc group?"
	read gitans
	gitans1=$(echo "$gitans" | tr 'a-z' 'A-Z')

#Searches for group ID in /etc/group and obtains value for GitAcc group

	if [[ $gitans1 == "YES" ]];
	then
	GID=$(cat /etc/group | grep GitAcc | awk -F ":" '{print $3}')

#Adds user using fullname specified earlier to GitAcc group based on group ID (GID)
#If user is added then it creates a bin directory in the user's home directory

	sudo adduser "$fullname" --gid "$GID"
	sudo su -c "mkdir /home/$fullname/bin" "$fullname"

#The autogit.sh file is copied from the shared folder to the bin directory to allow user to add,commit,and push

	cp /home/sharedgitfiles/autogit.sh /home/"$fullname"/bin
	sudo chown "$fullname" /home/"$fullname"/bin/autogit.sh

#Attempting to add the bin folder permanently to user's PATH
	su -c "echo "PATH=/home/$fullname/bin:$PATH" >> ~/.profile" "$fullname"

#Switches into newly created user's home directory
	su -l "$fullname"
	fi
fi
