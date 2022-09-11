#!/bin/python3
import subprocess, requests, json

url = 'https://api.football-data.org/v4/teams/61'

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
