""" rosettacode.org/wiki/Iccanobif_primes """

from sympy import isprime


def iccanobifs(wanted):
    """ Print the series of iccanobif prime numbers up to wanted """
    fib, prev, prevprev, fcount = 0, 1, 0, 0
    print('First 30 Iccanobif primes:')
    while fcount < wanted:
        fib = prev + prevprev
        prevprev = prev
        prev = fib
        dig = [int(c) for c in str(fib)]
        candidate = sum(n * 10**i for i, n in enumerate(dig))
        if isprime(candidate):
            fcount += 1
            dlen = len(str(candidate))
            if dlen < 90:
                print(candidate, f"({dlen} digit{'' if dlen == 1 else 's'})")
            else:
                s = str(candidate)
                print(s[:30], "...", s[-29:], f'({dlen} digits)')


iccanobifs(30)
