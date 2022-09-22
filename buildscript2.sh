#!/bin/bash
#==========================================================================================================================
#                                       Build Script #2
#==========================================================================================================================
# Author: Brayan Molina
# Date:   August 7th 2022
# Description: Demonstrate your ability to create a script that will automatically check the
# server’s processes and system performance.
#==========================================================================================================================
#  	                               Potential issues/bugs:
# 1. When given the option to kill a process, a user can still enter a value of any process rather than just the ones shown.
#==========================================================================================================================

#Color variables used for my output in the script.
green='\e[0;32m'
red='\e[0;31m'
clear='\e[0m'

#These options reflect a manual or automatic option I built. The user's choice is stored in variable pchoice.
#Pressing 2 = automatic will check for processes utilizing 30% or more of the systems memory.
#Pressing 1 = manual will provide the user with more instructions and allow them to input a specific value
#for memory% when checking processes. (i.e if user inputs 10 only processes using >10% mem will be shown)

echo "I can check your processes manually or automatically"
echo "Enter 1 = Manual"
echo "Enter 2 = Automatic"
read pchoice

#storing information about all processes sorted by memory% in variable var
var=$(ps -eo pid,uid,%mem,rsz,cmd --sort -%mem)


#MANUAL
#manual choice allows user to find programs that are utilizing more than a specified amount of the system's memory
if [[ $pchoice == "1" ]];
then
echo "Please enter a number. I will return processes using more memory than the value you specify. (1-99):"
read value
echo " "
echo "Checking processes using $value% or more of your system's memory"
sleep 1s

#This awk command filters through processes in the system and returns processes using more % mem than the value indicated by user.
#The output of this awk command is stored in variable mem. The option -v allows me to use a variable within the awk command.
mem=$(awk -v a="$value" 'NR==1; NR>1{
		if ($3 >= a)
		print $1,$2,$3,$4,$5}' <<< $var | column -t)

echo " "
echo "The following processes are using $value% or more of your memory:"
echo " "
echo "$mem"


#AUTOMATIC
#automatic choice is configured to show programs that are using more than 30% of the system's memory"
elif [[ $pchoice == "2" ]];
then
mem1=$(awk 'NR==1; NR>1{
                if ($3 >= 30)
		print $1,$2,$3,$4,$5}' <<< $var | column -t)

#if there are no available processes echo a statement otherwise show processes using >30% mem
	if [[ "$(wc -l <<< $mem1)" -eq 1 ]];
	then
	echo " "
	echo -e "${green}There are no available processes using more than 30% of your system's memory.${clear}"
	echo " "
	else
	echo " "
	echo -e "The following processes are using more than 30% of your system's memory. Please ${red}terminate${clear} the folowing processes."
	echo " "
	echo -e "${red}$mem1${clear}"
	fi
#linecount will be used to count the number of lines in the output of the ps command for the automatic option
linecount=$(wc -l <<< $mem1)

#This while loop offers the user the choice of killing the process if it uses more than 30% of the system's memory
#Loop will run until there are no more processes remaining or user answers no.
	while [[ $linecount > 1 ]];
	do
		echo " "
		echo "Would you like for me to terminate a process? Please answer yes or no"
		read yn
		if [[ $yn == "yes" ]];
		then
		echo " "
		echo "Please enter the PID of the process you would like to terminate"
		read pid
		kill $pid
		linecount=$((linecount-1))
		echo " "
		echo -e "${green}Successfully terminated process!${clear}"
		else
		exit
		fi
	done
fi
exit 0
