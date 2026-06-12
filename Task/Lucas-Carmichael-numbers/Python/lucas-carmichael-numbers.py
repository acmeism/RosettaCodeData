from sympy.ntheory import sieve, isprime, prime
from sympy.core import integer_nthroot
from math import lcm, gcd, isqrt

def lucas_carmichael(A, B, n):
    max_p = isqrt(B)+1

    def f(m, l, lo, k):

        if k == 1:

            lo = max(lo, A // m + (1 if A % m else 0))
            hi = min(B // m + 1, max_p)

            u = l - pow(m, -1, l)
            while u < lo: u += l
            if u > hi: return

            for p in range(u, hi, l):
                if (m*p+1) % (p+1) == 0 and isprime(p):
                    yield m*p

        else:
            hi = (integer_nthroot(B // m, k))[0]+1
            for p in sieve.primerange(lo, hi):
                if gcd(m, p+1) == 1:
                    yield from f(m*p, lcm(l, p+1), p + 2, k - 1)

    return sorted(f(1, 1, 3, n))

def LC_with_n_primes(n):
    x = 2
    y = 2*x
    while True:
        LC = lucas_carmichael(x, y, n)
        if len(LC) >= 1: return LC[0]
        x = y+1
        y = 2*x

def LC_count(A, B):
    k = 3
    l = 3*5*7
    count = 0
    while l < B:
        count += len(lucas_carmichael(A, B, k))
        k += 1
        l *= prime(k+1)
    return count

print("Least Lucas-Carmichael number with n prime factors:")

for n in range(3, 12+1):
    print("%2d: %d" % (n, LC_with_n_primes(n)))

print("\nNumber of Lucas-Carmichael numbers less than 10^n:")

for n in range(1, 10+1):
    print("%2d: %d" % (n, LC_count(1, 10**n)))
