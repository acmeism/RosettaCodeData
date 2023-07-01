def prime(a):
    return not (a < 2 or any(a % x == 0 for x in xrange(2, int(a**0.5) + 1)))

def primes_below(n):
    return [i for i in range(n) if prime(i)]
