import urllib.request

url = 'http://www.puzzlers.org/pub/wordlists/unixdict.txt'
words = urllib.request.urlopen(url).read().decode("utf-8").split()
ordered = [word for word in words if word==''.join(sorted(word))]
maxlen = len(max(ordered, key=len))
maxorderedwords = [word for word in ordered if len(word) == maxlen]
print(' '.join(maxorderedwords))
