import urllib.request as request

with request.urlopen("http://wiki.puzzlers.org/pub/wordlists/unixdict.txt") as f:
    a = f.read().decode("ASCII").split()

for s in a:
    if len(s) > 11 and "the" in s:
        print(s)
