""" rosettacode.org/wiki/Extreme_primes """

from sympy import isprime, nextprime

ecount, p, n = 0, 0, 0

while ecount < 50_000:
    p = nextprime(p)
    n += p
    if isprime(n):
        ecount += 1
        if ecount < 31:
            print(f'Sum of prime series up to {p}: prime {n}')
        if ecount in [1000, 2000, 3000, 4000, 5000, 30_000, 40_000, 50_000]:
            print(
                f'Sum of {ecount :,} in prime series up to {p :,}: prime {n :,}')
