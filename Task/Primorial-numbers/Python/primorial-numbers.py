from pyprimes import nprimes
from functools import reduce


primelist = list(nprimes(1000001))    # [2, 3, 5, ...]

def primorial(n):
    return reduce(int.__mul__, primelist[:n], 1)

if __name__ == '__main__':
    print('First ten primorals:', [primorial(n) for n in range(10)])
    for e in range(7):
        n = 10**e
        print('primorial(%i) has %i digits' % (n, len(str(primorial(n)))))
