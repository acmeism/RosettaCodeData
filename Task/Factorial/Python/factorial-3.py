from operator import mul

def factorial(n):
    return reduce(mul, xrange(1,n+1), 1)
