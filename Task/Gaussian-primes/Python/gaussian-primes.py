''' python example for task rosettacode.org/wiki/Gaussian_primes '''

from matplotlib.pyplot import scatter
from sympy import isprime
from math import isqrt

def norm(c):
    ''' Task complex norm function '''
    return c.real * c.real + c.imag * c.imag


def is_gaussian_prime(n):
    '''
        is_gaussian_prime(n)

    A Gaussian prime is a non-unit Gaussian integer m + ni divisible only by its associates and by the units
    1, i, -1, -i and by no other Gaussian integers.

    The Gaussian primes fall into one of three categories:

    Gaussian integers with imaginary part zero and a prime real part m with |m| a real prime satisfying |m| = 3 mod 4
    Gaussian integers with real part zero and an imaginary part n with |n| real prime satisfying  |n| = 3 mod 4
    Gaussian integers having both real and imaginary parts, and its complex norm (square of algebraic norm) is a real prime number
    '''
    r, c = int(abs(n.real)), int(abs(n.imag))
    return isprime(r * r + c * c) or c == 0 and isprime(r) and (r - 3) % 4 == 0 or r == 0 and isprime(c) and (c - 3) % 4 == 0

if __name__ == '__main__':

    limitsquared = 100
    lim = isqrt(limitsquared)
    testvals = [complex(r, c) for r in range(-lim, lim) for c in range(-lim, lim)]
    gprimes = sorted(filter(lambda c : is_gaussian_prime(c) and norm(c) < limitsquared, testvals), key=norm)
    print(f'Gaussian primes within {isqrt(limitsquared)} of the origin on the complex plane:')
    for i, c in enumerate(gprimes):
        print(str(c).ljust(9), end='\n' if (i +1) % 10 == 0 else '')
    scatter([c.real for c in gprimes], [c.imag for c in gprimes])
