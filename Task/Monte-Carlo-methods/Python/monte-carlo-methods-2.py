from random import random
from math import hypot
try:
    import psyco
    psyco.full()
except:
    pass

def pi(nthrows):
    inside = 0
    for i in xrange(nthrows):
        if hypot(random(), random()) < 1:
            inside += 1
    return 4.0 * inside / nthrows

for n in [10**4, 10**6, 10**7, 10**8]:
    print "%9d: %07f" % (n, pi(n))
