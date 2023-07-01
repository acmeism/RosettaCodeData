import urllib.request

mx, url = 0, 'http://www.puzzlers.org/pub/wordlists/unixdict.txt'

for word in urllib.request.urlopen(url).read().decode("utf-8").split():
    lenword = len(word)
    if lenword >= mx and word==''.join(sorted(word)):
        if lenword > mx:
            words, mx = [], lenword
        words.append(word)
print(' '.join(words))
