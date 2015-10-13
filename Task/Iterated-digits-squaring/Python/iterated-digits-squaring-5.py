from __future__ import print_function
from itertools import count

def check89(n):
    while True:
        n, t = 0, n
        while t: n, t = n + (t%10)**2, t//10
        if n <= 1: return False
        if n ==89: return True

a, sq, is89 = [1], [x**2 for x in range(1, 10)], [False]
for n in range(1, 500):
    b, a = a, a + [0]*81
    is89 += map(check89, range(len(b), len(a)))

    for i,v in enumerate(b):
        for s in sq: a[i + s] += v

    x = sum(a[i] for i in range(len(a)) if is89[i])
    print("10^%d" % n, x)
