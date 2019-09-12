#!/usr/bin/python3

from functools import lru_cache

def Z_S(n, f, k):
    """
    The cycle index of the symmetric group has recurrence
        Z(S_n, f(x)) = 1/n \sum_{i=1}^n f(x^i) Z(S_{n-i}, f(x)).
    This function finds the coefficient of x^k in Z(S_n, f(x))
    """
    # Special case to avoid division by zero
    if n == 0:
        return 1 if k == 0 else 0
    # Special case as a speed optimisation
    if n == 1:
        return f(k)
    return sum(
        sum(f(ij // i) * Z_S(n-i, f, k - ij) for ij in range(0, k+1, i))
        for i in range(1, n+1)
    ) // n

@lru_cache(maxsize=None)
def A000598(k): return 1 if k == 0 else Z_S(3, A000598, k-1)

@lru_cache(maxsize=None)
def A000642(k): return Z_S(2, A000598, k)

def A000631(k): return Z_S(2, A000642, k)

def A000602(k): return A000642(k) + (A000642((k-1) // 2) if k % 2 == 1 else 0) - A000631(k-1)

for k in range(500): print(k, A000602(k))
