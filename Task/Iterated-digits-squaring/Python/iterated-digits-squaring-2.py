from itertools import combinations_with_replacement
from array import array
from time import time
from math import factorial

F = [factorial(i) for i in range(18)]

for d in [8, 11, 14, 17]:
    def b(n):
        yield 1
        for g in range(1, n+1):
            gn = g
            res = 0
            while gn > 0:
                gn, rem = divmod(gn, 10)
                res += rem ** 2
            if res == 89:
                yield 0
            else:
                yield res

    N = array('I', b(81 * d))
    for n in range(2, len(N)):
        q = N[n]
        while q > 1:
            q = N[q]
        N[n] = q

    es = time()
    z = 0
    for n in combinations_with_replacement(range(10), d):
        t = 0
        for g in n:
            t += g * g
        if N[t] == 0:
            continue
        t = [0] * 10
        for g in n:
            t[g] += 1
        t1 = F[d]
        for g in t:
            t1 //= F[g]
        z += t1

    ee = time() - es
    print(f"{d} digits: {z} numbers produce 1 and {10 ** d - z} numbers produce 89")
    print("Time ~= %.3f secs\n" % ee)
