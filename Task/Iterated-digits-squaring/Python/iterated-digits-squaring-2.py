from itertools import combinations_with_replacement
from array import array
from time import clock
D = 8
F = [1, 1, 2, 6, 24, 120, 720, 5040, 40320, 362880, 3628800, 39916800, 479001600, 6227020800, 87178291200, 1307674368000, 20922789888000, 355687428096000]
def b(n):
    yield 1
    for g in range(1,n+1):
        gn = g
        res = 0
        while gn > 0:
            gn,rem = divmod(gn,10)
            res += rem**2
        if res==89:
            yield 0
        else:
            yield res
N = array('I',b(81*D))
for n in range(2,len(N)):
    q = N[n]
    while q>1:
        q = N[q]
    N[n] = q

es = clock()
z = 0
for n in combinations_with_replacement(range(10),D):
    t = 0
    for g in n:
        t += g*g
    if N[t] == 0:
        continue
    t = [0,0,0,0,0,0,0,0,0,0]
    for g in n:
        t[g] += 1
    t1 = F[D]
    for g in t:
        t1 /= F[g]
    z += t1
ee = clock() - es
print "\nD==" + str(D) + "\n  " + str(z) + " numbers produce 1 and " + str(10**D-z) + " numbers produce 89"
print "Time ~= " + str(ee) + " secs"
