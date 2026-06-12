import base64
import requests

url = "https://rosettacode.org/favicon.ico"
headers = { "User-Agent": "%Mozilla/5.0" }
response = requests.get(url, headers=headers)
if response.ok:
    result = base64.b64encode(response.content)
    print(f"{result[:50]}...{result[-50:]}".replace('b', '').replace("'", ""))
else:
    print(response.status_code)
