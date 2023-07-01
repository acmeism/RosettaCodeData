from math import sqrt
from itertools import imap, ifilter, islice, count

def factor_pairs(n):
    return ((x, n // x) for x in xrange(2, int(sqrt(n))) if n % x == 0)

def fangs(n):
    dlen = lambda x: len(str(x))
    half = dlen(n) // 2
    digits = lambda (x, y): sorted(str(x) + str(y))
    halvesQ = lambda xs: all(y == half for y in imap(dlen, xs))
    dn = sorted(str(n))
    return [p for p in factor_pairs(n) if halvesQ(p) and dn==digits(p)]

def vampiricQ(n):
    fn = fangs(n)
    return (n, fn) if fn else None

for v in islice(ifilter(None, imap(vampiricQ, count())), 0, 25):
    print v

for n in [16758243290880, 24959017348650, 14593825548650]:
    print vampiricQ(n) or str(n) + " is not vampiric."
