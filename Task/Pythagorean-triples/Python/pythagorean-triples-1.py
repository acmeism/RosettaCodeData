from fractions import gcd


def pt1(maxperimeter=100):
    '''
# Naive method
    '''
    trips = []
    for a in range(1, maxperimeter):
        aa = a*a
        for b in range(a, maxperimeter-a+1):
            bb = b*b
            for c in range(b, maxperimeter-b-a+1):
                cc = c*c
                if a+b+c > maxperimeter or cc > aa + bb: break
                if aa + bb == cc:
                    trips.append((a,b,c, gcd(a, b) == 1))
    return trips

def pytrip(trip=(3,4,5),perim=100, prim=1):
    a0, b0, c0 = a, b, c = sorted(trip)
    t, firstprim = set(), prim>0
    while a + b + c <= perim:
        t.add((a, b, c, firstprim>0))
        a, b, c, firstprim = a+a0, b+b0, c+c0, False
    #
    t2 = set()
    for a, b, c, firstprim in t:
        a2, a5, b2, b5, c2, c3, c7 = a*2, a*5, b*2, b*5, c*2, c*3, c*7
        if  a5 - b5 + c7 <= perim:
            t2 |= pytrip(( a - b2 + c2,  a2 - b + c2,  a2 - b2 + c3), perim, firstprim)
        if  a5 + b5 + c7 <= perim:
            t2 |= pytrip(( a + b2 + c2,  a2 + b + c2,  a2 + b2 + c3), perim, firstprim)
        if -a5 + b5 + c7 <= perim:
            t2 |= pytrip((-a + b2 + c2, -a2 + b + c2, -a2 + b2 + c3), perim, firstprim)
    return t | t2

def pt2(maxperimeter=100):
    '''
# Parent/child relationship method:
# http://en.wikipedia.org/wiki/Formulas_for_generating_Pythagorean_triples#XI.
    '''
    trips = pytrip((3,4,5), maxperimeter, 1)
    return trips

def printit(maxperimeter=100, pt=pt1):
    trips = pt(maxperimeter)
    print("  Up to a perimeter of %i there are %i triples, of which %i are primitive"
          % (maxperimeter,
             len(trips),
             len([prim for a,b,c,prim in trips if prim])))

for algo, mn, mx in ((pt1, 250, 2500), (pt2, 500, 20000)):
    print(algo.__doc__)
    for maxperimeter in range(mn, mx+1, mn):
        printit(maxperimeter, algo)
