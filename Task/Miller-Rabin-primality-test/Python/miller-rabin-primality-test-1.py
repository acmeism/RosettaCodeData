from random import randrange

def is_Prime(n: int):
    """
    Miller-Rabin primality test.

    A return value of False means n is certainly not prime. A return value of
    True means n is very likely a prime.
    """
    #Miller-Rabin test for primes
    if n in [2,3,5,7]:
        return True
    elif n<10:
        return False

    s = 0
    d = n-1
    while d%2==0:
        d>>=1
        s+=1
    assert(2**s * d == n-1)

    def trial_composite(a):
        if pow(a, d, n) == 1:
            return False
        for i in range(s):
            if pow(a, 2**i * d, n) == n-1:
                return False
        return True

    for i in range(8):#number of trials
        a = randrange(2, n)
        if trial_composite(a):
            return False

    return True
