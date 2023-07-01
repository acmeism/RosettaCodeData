""" Rosetta code Wagstaff_primes task """

from sympy import isprime

def wagstaff(N):
    """ find first N Wagstaff primes """
    pri, wcount = 1, 0
    while wcount < N:
        pri += 2
        if isprime(pri):
            wag = (2**pri + 1) // 3
            if isprime(wag):
                wcount += 1
                print(f'{wcount: 3}: {pri: 5} => ',
                      f'{wag:,}' if wcount < 11 else f'[{len(str(wag))} digit number]')


wagstaff(24)
