''' Rosetta code task: rosettacode.org/wiki/Zsigmondy_numbers '''

from math import gcd
from sympy import divisors


def zsig(num, aint, bint):
    ''' Get Zs(n, a, b) in task. '''
    assert aint > bint
    dexpms = [aint**i - bint**i for i in range(1, num)]
    dexpn = aint**num - bint**num
    return max([d for d in divisors(dexpn) if all(gcd(k, d) == 1 for k in dexpms)])


tests = [(2, 1), (3, 1), (4, 1), (5, 1), (6, 1),
         (7, 1), (3, 2), (5, 3), (7, 3), (7, 5)]
for (a, b) in tests:
    print(f'\nZsigmondy(n, {a}, {b}):', ', '.join(
        [str(zsig(n, a, b)) for n in range(1, 21)]))

