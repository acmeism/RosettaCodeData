import numpy
def primes_upto2(limit):
    is_prime = numpy.ones(limit + 1, dtype=numpy.bool)
    for n in xrange(2, int(limit**0.5 + 1.5)):
        if is_prime[n]:
            is_prime[n*n::n] = 0
    return numpy.nonzero(is_prime)[0][2:]
