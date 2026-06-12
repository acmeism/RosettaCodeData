#Aamrun, 4th October 2021

import urllib.request
urllib.request.urlretrieve("http://wiki.puzzlers.org/pub/wordlists/unixdict.txt", "unixdict.txt")

dictionary = open("unixdict.txt","r")

wordList = dictionary.read().split('\n')

dictionary.close()

oddWordSet = set({})

for word in wordList:
    if len(word)>=9 and word[::2] in wordList:
        oddWordSet.add(word[::2])

[print(i) for i in sorted(oddWordSet)]
