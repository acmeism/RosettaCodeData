#! /usr/bin/env python3
import datetime
import re
import urllib.request
import sys

def get(url):
    with urllib.request.urlopen(url) as response:
       html = response.read().decode('utf-8')
    if re.match(r'<!Doctype HTML[\s\S]*<Title>URL Not Found</Title>', html):
        return None
    return html

def main():
    template = 'http://tclers.tk/conferences/tcl/%Y-%m-%d.tcl'
    today = datetime.datetime.utcnow()
    back = 10
    needle = sys.argv[1]
    # Since Python does not come standard with time zone definitions, add an
    # extra day to account for the possible difference between the local and the
    # server time.
    for i in range(-back, 2):
        day = today + datetime.timedelta(days=i)
        url = day.strftime(template)
        haystack = get(url)
        if haystack:
            mentions = [x for x in haystack.split('\n') if needle in x]
            if mentions:
                print('{}\n------\n{}\n------\n'
                          .format(url, '\n'.join(mentions)))

main()
