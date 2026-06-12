#http://docs.python-requests.org/en/latest/
import requests
import json

city = None
topic = None

def getEvent(url_path, key) :
    responseString = ""

    params = {'city':city, 'key':key,'topic':topic}
    r = requests.get(url_path, params = params)
    print(r.url)
    responseString = r.text
    return responseString


def getApiKey(key_path):
    key = ""
    f = open(key_path, 'r')
    key = f.read()
    return key


def submitEvent(url_path,params):
    r = requests.post(url_path, data=json.dumps(params))
    print(r.text+" : Event Submitted")
