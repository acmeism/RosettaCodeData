from __future__ import print_function
from prime_decomposition import primes, is_prime
from heapq import *
from itertools import islice

def emirp():
    largest = set()
    emirps = []
    heapify(emirps)
    for pr in primes():
        while emirps and pr > emirps[0]:
            yield heappop(emirps)
        if pr in largest:
            yield pr
        else:
            rp = int(str(pr)[::-1])
            if rp > pr and is_prime(rp):
                heappush(emirps, pr)
                largest.add(rp)

print('First 20:\n  ', list(islice(emirp(), 20)))
print('Between 7700 and 8000:\n  [', end='')
for pr in emirp():
    if pr >= 8000: break
    if pr >= 7700: print(pr, end=', ')
print(']')
print('10000th:\n  ', list(islice(emirp(), 10000-1, 10000)))
