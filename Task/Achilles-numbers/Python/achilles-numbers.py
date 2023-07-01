from math import gcd
from sympy import factorint

def is_Achilles(n):
    p = factorint(n).values()
    return all(i > 1 for i in p) and gcd(*p) == 1

def is_strong_Achilles(n):
    return is_Achilles(n) and is_Achilles(totient(n))

def test_strong_Achilles(nachilles, nstrongachilles):
    # task 1
    print('First', nachilles, 'Achilles numbers:')
    n, found = 0, 0
    while found < nachilles:
        if is_Achilles(n):
            found += 1
            print(f'{n: 8,}', end='\n' if found % 10 == 0 else '')
        n += 1

    # task 2
    print('\nFirst', nstrongachilles, 'strong Achilles numbers:')
    n, found = 0, 0
    while found < nstrongachilles:
        if is_strong_Achilles(n):
            found += 1
            print(f'{n: 9,}', end='\n' if found % 10 == 0 else '')
        n += 1

    # task 3
    print('\nCount of Achilles numbers for various intervals:')
    intervals = [[10, 99], [100, 999], [1000, 9999], [10000, 99999], [100000, 999999]]
    for interval in intervals:
        print(f'{interval}:', sum(is_Achilles(i) for i in range(*interval)))


test_strong_Achilles(50, 100)
