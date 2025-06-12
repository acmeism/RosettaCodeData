import requests
import operator
import re

api_url    = 'http://rosettacode.org/w/api.php'
languages  = {}

parameters = {
    'format':       'json',
    'action':       'query',
    'generator':    'categorymembers',
    'gcmtitle':     'Category:Programming Languages',
    'gcmlimit':     '200',
    'gcmcontinue':  '',
    'continue':     '',
    'prop':         'categoryinfo'
}

headers = {
  'User-Agent': 'Rosetta Code Task bot'
}

while(True):
    response = requests.get(api_url, params=parameters, headers=headers).json()
    for k,v in response['query']['pages'].items():
        if 'title' in v and 'categoryinfo' in v:
          languages[v['title']]=v['categoryinfo']['size']
    if 'continue' in response:
        gcmcontinue = response['continue']['gcmcontinue']
#        print(gcmcontinue)
        parameters.update({'gcmcontinue': gcmcontinue})
    else:
        break

# report top 15 languages
for i, (language, size) in enumerate(sorted(languages.items(), key=operator.itemgetter(1), reverse=True)[:15]):
    print("{:4d} {:4d} - {}".format(i+1, size, re.sub('Category:','',language))) # strip Category: from language
