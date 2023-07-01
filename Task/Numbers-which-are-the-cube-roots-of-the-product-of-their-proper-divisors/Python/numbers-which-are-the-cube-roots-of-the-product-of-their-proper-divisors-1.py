''' Rosetta code rosettacode.org/wiki/Numbers_which_are_the_cube_roots_of_the_product_of_their_proper_divisors '''

from functools import reduce
from sympy import divisors


FOUND = 0
for num in range(1, 1_000_000):
    divprod = reduce(lambda x, y: x * y, divisors(num)[:-1])if num > 1 else 1
    if num * num * num == divprod:
        FOUND += 1
        if FOUND <= 50:
            print(f'{num:5}', end='\n' if FOUND % 10 == 0 else '')
        if FOUND == 500:
            print(f'\nFive hundreth: {num:,}')
        if FOUND == 5000:
            print(f'\nFive thousandth: {num:,}')
        if FOUND == 50000:
            print(f'\nFifty thousandth: {num:,}')
            break
