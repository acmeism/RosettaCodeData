from numpy import prod

def factorial(n):
    return prod(range(1, n + 1), dtype=int)
