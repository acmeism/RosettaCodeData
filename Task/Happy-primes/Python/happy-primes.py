''' rosettacode.org/wiki/Happy_primes '''

import itertools
from sympy import isprime


def is_happy(n):
    """Check if a number is happy"""
    while n not in (1, 4):
        n = sum(int(d) ** 2 for d in str(n) if d != '0')
    return n == 1

# Generate happy prime numbers
happy_prime_nums = filter(lambda x: is_happy(
    x) and isprime(x), itertools.count(1))

print("First fifty happy primes:")
happy_primes = list(itertools.islice(happy_prime_nums, 50))
for i in range(50):
    print(f"{happy_primes[i]:4d}", end="")
    print("\n" if (i + 1) % 10 == 0 else " ", end="")

# Chart fractional growth in happy numbers versus prime happy numbers
print("\nPrime")
print("Fraction   Index     Value")
print("=" * 26)
IDX = 1
PCOUNT = 0
HAPPYS = filter(is_happy, itertools.count(2))

for d in range(2, 16):
    while True:
        IDX += 1
        m = next(HAPPYS)
        if isprime(m):
            PCOUNT += 1
        if PCOUNT / IDX <= 1/d:
            break
    print(f"1 / {d:2d}{IDX:10d}{m:10d}")

