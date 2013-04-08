import urllib.request, itertools
import time
words = urllib.request.urlopen('http://www.puzzlers.org/pub/wordlists/unixdict.txt').read().split()
print('Words ready')
t0 = time.clock()
anagrams = [list(g) for k,g in itertools.groupby(sorted(words, key=sorted), key=sorted)]
anagrams.sort(key=len, reverse=True)
count = len(anagrams[0])
for ana in anagrams:
    if len(ana) < count:
        break
    print(ana)
t0 -= time.clock()
print('Finished in %f s' % -t0)
