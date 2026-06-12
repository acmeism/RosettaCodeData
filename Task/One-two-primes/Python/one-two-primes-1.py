""" rosettacode.org/wiki/One-two_primes """
from itertools import permutations
from gmpy2 import is_prime


def oeis36229(wanted=20):
    ''' get first [wanted] entries in OEIS A036229 '''
    for ndig in range(1, wanted + 1):
        if ndig < 21 or ndig % 100 == 0:
            dig = ['1' for _ in range(ndig)] + ['2' for _ in range(ndig)]
            for arr in permutations(dig, ndig):
                candidate = int(''.join(arr))
                if is_prime(candidate):
                    print(f'{ndig:4}: ', candidate)
                    break


oeis36229()
