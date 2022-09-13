#!/bin/python3
#=================================================================================================================
#                                       Build Script #4
#=================================================================================================================
# Author: Brayan Molina
# Date:   September 13th 2022
# Description: Demonstrate your ability to gather data from an API and organize that data into a specific format.
#=================================================================================================================
#                                      Instructions:
# The script will return squad information related to premier league teams for the 2022-2023 season.
#=================================================================================================================

#Importing methods to run script properly
import subprocess, requests, json, time

#Output of instructions for user
print("This script will store squad information about the English Premier League teams for the current season in a csv file")
time.sleep(1.5)
print("Please select a team from the list below\n")
time.sleep(2)

#Dictionary of premier league teams that will be used based on user input
pl_tv = {'Arsenal':57,'Aston Villa':58,'Chelsea':61,'Everton':62,'Fulham':63,'Liverpool':64,'Manchester City':65,'Manchester United':66,'Newcastle':67,'Tottenham Hotspurs':73,
		'Wolverhampton Wanderers':76,'Leicester City':338,'Southampton':340,'Leeds United':341,
		'Nottingham Forest':351,'Crystal Palace':354,'Brighton & Hove Albion':397,'Brentford':402,'West Ham':563,'Bournemouth':1044}

#Creating list of team names from dictionary and running a for loop to show user list of teams.
pl_teams = list(pl_tv.keys())

for teams in pl_teams:
	print("{}\n".format(teams))

#storing team user selected in variable team_selected.
team_selected = input("")

#url for API will retrieve information based on the team that was selected using dictionary key:pair values.
url = 'https://api.football-data.org/v4/teams/{}'.format(pl_tv[team_selected])

#Token used to access API and headers that help with formatting output in JSON structure
headers = {
	"X-Auth-Token": "775d48413ec742418c53e5cf5f650a82",
	"Accept": "application/json",
	"Content-Type": "application/json",
	}

#GET request from API URL using the headers provided
response = requests.request("GET", url, headers=headers)

#using imported JSON method to turn raw data into a more readable format.
data_json = response.json()
final_result = json.dumps(data_json, indent=4)
string_result = str(final_result)

#Writing data from API into JSON file.
with open ('./squad.json','w') as open_json:
	open_json.write(string_result)

#Using subprocess to run Bash commands jq and dasel to turn JSON into csv
squad_filter=subprocess.run(["cat squad.json | jq '.squad | [.[] | {Name: .name, Position: .position,DOB: .dateOfBirth,Nationality: .nationality}]' | dasel -r json -w csv > squad.csv"], shell=True, text=True, capture_output=True)
