from __future__ import division
from math import log2

def hist(source):
    hist, l = {}, 0
    for e in source:
        l += 1
        if e not in hist:
            hist[e] = 0
        hist[e] += 1
    return (l, hist)

def entropy(hist: dict, l):
    elist = []
    for v in hist.values():
        c = v / l
        elist.append(-c * log2(c))
    return sum(elist)

def printHist(h: dict):
    flip = lambda k, v: (v, k)
    h = sorted(h.items(), key = lambda x: flip(*x))
    print('Sym\thi\tfi\tInf')
    for (k, v) in h:
        print('%s\t%f\t%f\t%f' % (k, v, v/l, -log2(v/l)))

source = '1223334444'
(l, h) = hist(source)
print('.[Results].')
print('Length', l)
print('Entropy:', entropy(h, l))
printHist(h)
