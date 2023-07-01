# https://docs.sympy.org/latest/modules/ntheory.html#sympy.ntheory.factor_.divisors
from sympy import divisors

def chowla(n):
    return 0 if n < 2 else sum(divisors(n, generator=True)) - 1 -n

def is_prime(n):
    return chowla(n) == 0

def primes_to(n):
    return sum(chowla(i) == 0 for i in range(2, n))

def perfect_between(n, m):
    c = 0
    print(f"\nPerfect numbers between [{n:_}, {m:_})")
    for i in range(n, m):
        if i > 1 and chowla(i) == i - 1:
            print(f"  {i:_}")
            c += 1
    print(f"Found {c} Perfect numbers between [{n:_}, {m:_})")


if __name__ == '__main__':
    for i in range(1, 38):
        print(f"chowla({i:2}) == {chowla(i)}")
    for i in range(2, 6):
        print(f"primes_to({10**i:_}) == {primes_to(10**i):_}")
    perfect_between(1, 1_000_000)
    print()
    for i in range(6, 8):
        print(f"primes_to({10**i:_}) == {primes_to(10**i):_}")
    perfect_between(1_000_000, 35_000_000)
