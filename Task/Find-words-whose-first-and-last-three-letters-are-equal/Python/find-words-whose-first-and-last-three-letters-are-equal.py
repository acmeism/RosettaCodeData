import urllib.request
urllib.request.urlretrieve("http://wiki.puzzlers.org/pub/wordlists/unixdict.txt", "unixdict.txt")

dictionary = open("unixdict.txt","r")

wordList = dictionary.read().split('\n')

dictionary.close()

for word in wordList:
    if len(word)>5 and word[:3].lower()==word[-3:].lower():
        print(word)
