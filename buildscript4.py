#!/bin/python3
import subprocess, requests, json, time

print("This script will store squad information about the English Premier League teams for the current season in a csv file")
time.sleep(3)
print("Please select a team from the list below\n")
time.sleep(3)

pl_tv = {'Arsenal':57,'Aston Villa':58,'Chelsea':61,'Everton':62,'Fulham':63,'Liverpool':64,'Manchester City':65,'Manchester United':66,'Newcastle':67,'Tottenham Hotspurs':73,
		'Wolverhampton Wanderers':76,'Leicester City':338,'Southampton':340,'Leeds United':341,
		'Nottingham Forest':351,'Crystal Palace':354,'Brighton & Hove Albion':397,'Brentford':402,'West Ham':563,'Bournemouth':1044}

pl_teams = list(pl_tv.keys())

for teams in pl_teams:
	print(teams)

team_selected = input("")

url = 'https://api.football-data.org/v4/teams/{}'.format(pl_tv[team_selected])

headers = {
	"X-Auth-Token": "775d48413ec742418c53e5cf5f650a82",
	"Accept": "application/json",
	"Content-Type": "application/json",
	}

response = requests.request("GET", url, headers=headers)

data_json = response.json()
final_result = json.dumps(data_json, indent=4)
string_result = str(final_result)
with open ('./squad.json','w') as open_json:
	open_json.write(string_result)


squad_filter=subprocess.run(["cat squad.json | jq '.squad | [.[] | {Name: .name, Position: .position,DOB: .dateOfBirth,Nationality: .nationality}]' | dasel -r json -w csv > squad.csv"], shell=True, text=True, capture_output=True)
