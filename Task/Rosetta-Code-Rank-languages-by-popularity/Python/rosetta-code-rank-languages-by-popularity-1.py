import requests
import re

response = requests.get("http://rosettacode.org/wiki/Category:Programming_Languages").text
languages = re.findall('title="Category:(.*?)">',response)[:-3] # strip last 3

response = requests.get("http://rosettacode.org/mw/index.php?title=Special:Categories&limit=5000").text
response = re.sub('(\d+),(\d+)',r'\1'+r'\2',response)           # strip ',' from popular languages above 999 members
members  = re.findall('<li><a[^>]+>([^<]+)</a>[^(]*[(](\\d+) member[s]*[)]</li>',response) # find language and members

for cnt, (language, members) in enumerate(sorted(members, key=lambda x: -int(x[1]))[:15]): # show only top 15 languages
    if language in languages:
        print("{:4d} {:4d} - {}".format(cnt+1, int(members), language))
