from numba import jit

# https://docs.sympy.org/latest/modules/ntheory.html#sympy.ntheory.factor_.divisors
from sympy import divisors

@jit
def chowla(n):
    return 0 if n < 2 else sum(divisors(n, generator=True)) - 1 -n

@jit
def is_prime(n):
    return chowla(n) == 0

@jit
def primes_to(n):
    acc = 0
    for i in range(2, n):
        if chowla(i) == 0:
            acc += 1
    return acc

@jit
def _perfect_between(n, m):
    for i in range(n, m):
        if i > 1 and chowla(i) == i - 1:
            yield i

def perfect_between(n, m):
    c = 0
    print(f"\nPerfect numbers between [{n:_}, {m:_})")
    for i in _perfect_between(n, m):
        print(f"  {i:_}")
        c += 1
    print(f"Found {c} Perfect numbers between [{n:_}, {m:_})")
