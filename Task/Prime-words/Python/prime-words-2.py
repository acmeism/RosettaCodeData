#Aamrun, 6th November 2021

import urllib.request
from collections import Counter

urllib.request.urlretrieve("http://wiki.puzzlers.org/pub/wordlists/unixdict.txt", "unixdict.txt")

dictionary = open("unixdict.txt","r")

wordList = dictionary.read().split('\n')

dictionary.close()

primeSet = set("CGIOSYaegkmq")

[print(word) for word in wordList if len(set(word).difference(primeSet))==0]
