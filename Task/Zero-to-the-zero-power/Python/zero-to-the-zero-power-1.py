from decimal import Decimal
from fractions import Fraction
from itertools import product

zeroes = [0, 0.0, 0j, Decimal(0), Fraction(0, 1), -0.0, -0.0j, Decimal(-0.0)]
for i, j in product(zeroes, repeat=2):
    try:
        ans = i**j
    except:
        ans = '<Exception raised>'
    print(f'{i!r:>15} ** {j!r:<15} = {ans!r}')
