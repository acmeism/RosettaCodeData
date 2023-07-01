import pyprimes

def primorial_prime(_pmax=500):
    isprime = pyprimes.isprime
    n, primo = 0, 1
    for prime in pyprimes.nprimes(_pmax):
        n, primo = n+1, primo * prime
        if isprime(primo-1) or isprime(primo+1):
            yield n

if __name__ == '__main__':
    # Turn off warning on use of probabilistic formula for prime test
    pyprimes.warn_probably = False
    for i, n in zip(range(20), primorial_prime()):
        print('Primorial prime %2i at primorial index: %3i' % (i+1, n))
