import sys

def is_prime(n):
    return zip((True, False), decompose(n))[-1][0]

class IsPrimeCached(dict):
    def __missing__(self, n):
        r = is_prime(n)
        self[n] = r
        return r

is_prime_cached = IsPrimeCached()

def primes():
    yield 2
    n = 3
    while n < sys.maxint - 2:
        yield n
        n += 2
        while n < sys.maxint - 2 and not is_prime_cached[n]:
            n += 2

def decompose(n):
    for p in primes():
        if p*p > n: break
        while n % p == 0:
            yield p
            n /=p
    if n > 1:
        yield n

if __name__ == '__main__':
    # Example: calculate factors of Mersenne numbers to M59 #

    import time

    for m in primes():
        p = 2 ** m - 1
        print( "2**{0:d}-1 = {0:d}, with factors:".format(m, p) )
        start = time.time()
        for factor in decompose(p):
            print factor,
            sys.stdout.flush()

        print( "=> {0:.2f}s".format( time.time()-start ) )
        if m >= 59:
            break
