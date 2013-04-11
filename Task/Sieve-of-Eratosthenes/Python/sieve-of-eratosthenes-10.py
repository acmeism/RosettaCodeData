def primes():
    yield 2 ; yield 3 ; yield 5 ; yield 7 ;
    ps = (p for p in primes())              # additional primes supply
    p = ps.next() and ps.next()             # discard 2, then get 3
    q = p*p                                 # 9 - square of next prime to be put
    sieve = {}                              #       into sieve dict
    n = 9                                   # the candidate number
    while True:
        if n not in sieve:                  # is not a multiple of previously recorded primes
            if n < q:                       # n is prime
                yield n
            else:
                add(sieve, q + 2*p, 2*p)    # n==p*p: for prime p, under p*p + 2*p,
                p = ps.next()               #         add 2*p as incremental step
                q = p*p
        else:
            s = sieve.pop(n)
            add(sieve, n + s, s)
        n += 2                              # work on odds only

def add(sieve,next,step):
    while next in sieve:                    # ensure each entry is unique
        next += step
    sieve[next] = step                      # next non-marked multiple of a prime

import itertools
def primes_up_to(limit):
    return list(itertools.takewhile(lambda p: p <= limit, primes()))
