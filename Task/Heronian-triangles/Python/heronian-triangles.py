from __future__ import division, print_function
from math import gcd, sqrt


def hero(a, b, c):
    s = (a + b + c) / 2
    a2 = s * (s - a) * (s - b) * (s - c)
    return sqrt(a2) if a2 > 0 else 0


def is_heronian(a, b, c):
    a = hero(a, b, c)
    return a > 0 and a.is_integer()


def gcd3(x, y, z):
    return gcd(gcd(x, y), z)


if __name__ == '__main__':
    MAXSIDE = 200

    N = 1 + MAXSIDE
    h = [(x, y, z)
         for x in range(1, N)
         for y in range(x, N)
         for z in range(y, N) if (x + y > z) and
         1 == gcd3(x, y, z) and
         is_heronian(x, y, z)]

    # By increasing area, perimeter, then sides
    h.sort(key=lambda x: (hero(*x), sum(x), x[::-1]))

    print(
        'Primitive Heronian triangles with sides up to %i:' % MAXSIDE, len(h)
    )
    print('\nFirst ten when ordered by increasing area, then perimeter,',
          'then maximum sides:')
    print('\n'.join('  %14r perim: %3i area: %i'
                    % (sides, sum(sides), hero(*sides)) for sides in h[:10]))
    print('\nAll with area 210 subject to the previous ordering:')
    print('\n'.join('  %14r perim: %3i area: %i'
                    % (sides, sum(sides), hero(*sides)) for sides in h
                    if hero(*sides) == 210))
