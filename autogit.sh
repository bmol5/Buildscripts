#!/bin/bash
#==============================================================================================>
#                                       Build Script #3
#==============================================================================================>
# Author: Brayan Molina
# Date:   August 17th 2022
# Objective: Adds and commits for the user. This script checks for social security numbers
# before pushing to Github.
#==============================================================================================>
#                                      Instructions:
# 1. This is a continuation of buildscript3.sh and can be ran by any user.
# #=============================================================================================

#Prompts user to answer if they are ready to commit
echo "Are you ready to add and commit? (yes/no)"
read yn

#translates all inputs of yes to capital YES to avoid wrong inputs
yn1=$(tr 'a-z' 'A-Z' <<< $yn)

#variables containing social security patterns. Ranges for SS are (0-772)-(0-99)-(0-9999).
si='[0-7][0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9]'
si2='[0-7][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'

#If user prompts they are ready to commits then loop asks for file name and commit message.
#grep function searches file provided by user for social security patterns in variables si, si2
if [[ $yn1 = "YES" ]];
then
	echo "Type out the name of the file you are looking to commit"
	read file
	echo "Type out the message you would like to include in your commit"
	read message
	git add "$file"
	git commit -m "$message"
	echo "=============================="
	echo "Succesfully added your commit!"
	echo "=============================="

elif [[ $yn1 = "NO" ]];
then
exit
fi
#Prompts user for confirmation they would like to push to remote repository
#Prompts user for name of remote repository and the branch they want to push to
echo "Would you like to push to your remote repository? (yes/no)"
read ans
ans1=$(tr 'a-z' 'A-Z' <<< $ans)

#grep searches for social security information based on patterns stored in variables si and si2
if [[ $ans1 = "YES" ]];
then
	if grep -o "$si" $file || grep -o "$si2" $file
	then
       	echo "We have detected sensitive information. Please remove information before pushing."
	exit
	elif [ -z $(grep -o "$si" $file || grep -o "$si2" $file) ];
	then
	git push
	fi
fi

#Should the user just want to commit, but not push they could answer no to not push to github.
if [[ $ans1 = "NO" ]];
then
echo "Your latest commit was not pushed to remote repository."
exit
fi

exit 0
