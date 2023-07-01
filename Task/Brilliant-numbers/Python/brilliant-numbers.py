from primesieve.numpy import primes
from math import isqrt
import numpy as np

max_order = 9
blocks = [primes(10**n, 10**(n + 1)) for n in range(max_order)]

def smallest_brilliant(lb):
    pos = 1
    root = isqrt(lb)

    for blk in blocks:
        n = len(blk)
        if blk[-1]*blk[-1] < lb:
            pos += n*(n + 1)//2
            continue

        i = np.searchsorted(blk, root, 'left')
        i += blk[i]*blk[i] < lb

        if not i:
            return blk[0]*blk[0], pos

        p = blk[:i + 1]
        q = (lb - 1)//p
        idx = np.searchsorted(blk, q, 'right')

        sel = idx < n
        p, idx = p[sel], idx[sel]
        q = blk[idx]

        sel = q >= p
        p, q, idx = p[sel], q[sel], idx[sel]

        pos += np.sum(idx - np.arange(len(idx)))
        return np.min(p*q), pos

res = []
p = 0
for i in range(100):
    p, _ = smallest_brilliant(p + 1)
    res.append(p)

print(f'first 100 are {res}')

for i in range(max_order*2):
    thresh = 10**i
    p, pos = smallest_brilliant(thresh)
    print(f'Above 10^{i:2d}: {p:20d} at #{pos}')
