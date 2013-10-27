from __future__ import division
import math

def hist(source):
    hist = {}; l = 0;
    for e in source:
        l += 1
        if e not in hist:
            hist[e] = 0
        hist[e] += 1
    return (l,hist)

def entropy(hist,l):
    elist = []
    for v in hist.values():
        c = v / l
        elist.append(-c * math.log(c ,2))
    return sum(elist)

def printHist(h):
    flip = lambda (k,v) : (v,k)
    h = sorted(h.iteritems(), key = flip)
    print 'Sym\thi\tfi\tInf'
    for (k,v) in h:
        print '%s\t%f\t%f\t%f'%(k,v,v/l,-math.log(v/l, 2))



source = "1223334444"
(l,h) = hist(source);
print '.[Results].'
print 'Length',l
print 'Entropy:', entropy(h, l)
printHist(h)
