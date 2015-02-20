from numpy import array, bool_, multiply, nonzero, ones, put, resize
#
def makepattern(smallprimes):
    pattern = ones(multiply.reduce(smallprimes), dtype=bool_)
    pattern[0] = 0
    for p in smallprimes:
        pattern[p::p] = 0
    return pattern
#
def primes_upto3(limit, smallprimes=(2,3,5,7,11)):
    sp = array(smallprimes)
    if limit <= sp.max(): return sp[sp <= limit]
    #
    isprime = resize(makepattern(sp), limit + 1)
    isprime[:2] = 0; put(isprime, sp, 1)
    #
    for n in range(sp.max() + 2, int(limit**0.5 + 1.5), 2):
        if isprime[n]:
            isprime[n*n::n] = 0
    return nonzero(isprime)[0]
