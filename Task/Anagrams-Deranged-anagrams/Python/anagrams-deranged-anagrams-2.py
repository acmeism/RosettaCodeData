from itertools import izip, ifilter
from collections import defaultdict

def find_deranged(words):
    result = []
    for i, w1 in enumerate(words):
        for w2 in words[i+1:]:
            if all(a != b for a,b in izip(w1, w2)):
                result.append((w1, w2))
    return result

def main():
    wclasses = [[] for _ in xrange(30)]
    for word in open("unixdict.txt").read().split():
        wclasses[-len(word)].append(word)
    print "Longest deranged anagrams:"
    for words in ifilter(None, wclasses):
        anags = defaultdict(list)
        for w in words:
            anags["".join(sorted(w))].append(w)
        anas = (find_deranged(a) for a in anags.itervalues() if len(a)>1)
        pairs = filter(None, anas)
        if pairs:
            print "  %s, %s" % (pairs[0][0])
            break

main()
