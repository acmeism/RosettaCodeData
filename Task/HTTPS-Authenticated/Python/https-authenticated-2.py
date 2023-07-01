import requests

username = "user"
password = "pass"
url = "https://www.example.com"

response = requests.get(url, auth=(username, password)

print(response.text)
