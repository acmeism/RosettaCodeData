""" Rosetta code task: Smallest_multiple """

from math import gcd
from functools import reduce


def lcm(a, b):
    """ least common multiple """
    return 0 if 0 == a or 0 == b else (
        abs(a * b) // gcd(a, b)
    )


for i in [10, 20, 200, 2000]:
    print(str(i) + ':', reduce(lcm, range(1, i + 1)))
