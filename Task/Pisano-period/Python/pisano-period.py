from sympy import isprime, lcm, factorint, primerange
from functools import reduce


def pisano1(m):
    "Simple definition"
    if m < 2:
        return 1
    lastn, n = 0, 1
    for i in range(m ** 2):
        lastn, n = n, (lastn + n) % m
        if lastn == 0 and n == 1:
            return i + 1
    return 1

def pisanoprime(p, k):
    "Use conjecture π(p ** k) == p ** (k − 1) * π(p) for prime p and int k > 1"
    assert isprime(p) and k > 0
    return p ** (k - 1) * pisano1(p)

def pisano_mult(m, n):
    "pisano(m*n) where m and n assumed coprime integers"
    return lcm(pisano1(m), pisano1(n))

def pisano2(m):
    "Uses prime factorization of m"
    return reduce(lcm, (pisanoprime(prime, mult)
                        for prime, mult in factorint(m).items()), 1)


if __name__ == '__main__':
    for n in range(1, 181):
        assert pisano1(n) == pisano2(n), "Wall-Sun-Sun prime exists??!!"
    print("\nPisano period (p, 2) for primes less than 50\n ",
          [pisanoprime(prime, 2) for prime in primerange(1, 50)])
    print("\nPisano period (p, 1) for primes less than 180\n ",
          [pisanoprime(prime, 1) for prime in primerange(1, 180)])
    print("\nPisano period (p) for integers 1 to 180")
    for i in range(1, 181):
        print(" %3d" % pisano2(i), end="" if i % 10 else "\n")
