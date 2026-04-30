from bitarray.util import gen_primes
from math import isqrt
from functools import cache
from time import perf_counter

def countPrimes(limit):
    if limit < 2: return 0

    rtlmtsz = isqrt(limit) + 1
    sieve = gen_primes(rtlmtsz)
    baseprms = [ pi for pi in range(rtlmtsz) if sieve[pi] ]
    nbps = len(baseprms)

    @cache
    def phi(x, a): # termination condition means x and a can never be zero
        rslt = x
        for na in range(a - 1, -1, -1): # loop takes care of a zero termination!
            pna = baseprms[na]
            if pna * pna > x: rslt -= 1; continue # termination before x is zero
            if na: rslt -= phi(x // pna, na) # lessening recursion depth
            else: rslt -= x // pna
        return rslt

    return phi(limit, nbps) + nbps - 1

start = perf_counter()
for exp in range(10):
    print(f'10**{exp}: ', countPrimes(10**exp))
stop = perf_counter()
print(f"This took {(stop - start) * 1000:.0f} milliseconds.")
