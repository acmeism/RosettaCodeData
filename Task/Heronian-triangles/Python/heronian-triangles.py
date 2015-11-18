from __future__ import division, print_function
from math import sqrt
from fractions import gcd
from itertools import product


def hero(a, b, c):
    s = (a + b + c) / 2
    a2 = s*(s-a)*(s-b)*(s-c)
    return sqrt(a2) if a2 > 0 else 0


def is_heronian(a, b, c):
    a = hero(a, b, c)
    return a > 0 and a.is_integer()


def gcd3(x, y, z):
    return gcd(gcd(x, y), z)


if __name__ == '__main__':
    maxside = 200
    h = [(a, b, c) for a,b,c in product(range(1, maxside + 1), repeat=3)
         if a <= b <= c and a + b > c and gcd3(a, b, c) == 1 and is_heronian(a, b, c)]
    h.sort(key = lambda x: (hero(*x), sum(x), x[::-1]))   # By increasing area, perimeter, then sides
    print('Primitive Heronian triangles with sides up to %i:' % maxside, len(h))
    print('\nFirst ten when ordered by increasing area, then perimeter,then maximum sides:')
    print('\n'.join('  %14r perim: %3i area: %i'
                    % (sides, sum(sides), hero(*sides)) for sides in h[:10]))
    print('\nAll with area 210 subject to the previous ordering:')
    print('\n'.join('  %14r perim: %3i area: %i'
                    % (sides, sum(sides), hero(*sides)) for sides in h
                    if hero(*sides) == 210))
