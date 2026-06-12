from itertools import permutations
from operator import mul
from math import fsum, factorial
from functools import reduce
from operator import itemgetter

DEBUG = False  # like the built-in __debug__


def spermutations(n):
    """permutations by swapping. Yields: perm, sign"""
    sign = 1
    p = [[i, 0 if i == 0 else -1]  # [num, direction]
         for i in range(n)]

    if DEBUG: print(' #', p)
    yield tuple(pp[0] for pp in p), sign

    while any(pp[1] for pp in p):  # moving
        i1, (n1, d1) = max(((i, pp) for i, pp in enumerate(p) if pp[1]),
                           key=itemgetter(1))
        sign *= -1
        if d1 == -1:
            # Swap down
            i2 = i1 - 1
            p[i1], p[i2] = p[i2], p[i1]
            # If this causes the chosen element to reach the First or last
            # position within the permutation, or if the next element in the
            # same direction is larger than the chosen element:
            if i2 == 0 or p[i2 - 1][0] > n1:
                # The direction of the chosen element is set to zero
                p[i2][1] = 0
        elif d1 == 1:
            # Swap up
            i2 = i1 + 1
            p[i1], p[i2] = p[i2], p[i1]
            # If this causes the chosen element to reach the first or Last
            # position within the permutation, or if the next element in the
            # same direction is larger than the chosen element:
            if i2 == n - 1 or p[i2 + 1][0] > n1:
                # The direction of the chosen element is set to zero
                p[i2][1] = 0
        if DEBUG: print(' #', p)
        yield tuple(pp[0] for pp in p), sign

        for i3, pp in enumerate(p):
            n3, d3 = pp
            if n3 > n1:
                pp[1] = 1 if i3 < i2 else -1
                if DEBUG: print(' # Set Moving')


def prod(lst):
    return reduce(mul, lst, 1)


def is_antisymmetric(a):
    """Check if a matrix is antisymmetric"""
    n = len(a)
    for i in range(n):
        if a[i][i] != 0:  # Diagonal elements must be zero
            return False
        for j in range(i + 1, n):
            if a[i][j] != -a[j][i]:
                return False
    return True


def is_symmetric(a):
    """Check if a matrix is symmetric"""
    n = len(a)
    for i in range(n):
        for j in range(i + 1, n):
            if a[i][j] != a[j][i]:
                return False
    return True


def pfaffian(a):
    """Compute the Pfaffian of a 2n x 2n antisymmetric matrix."""
    n = len(a) // 2

    if len(a) % 2 != 0:
        raise ValueError("Matrix must be 2n x 2n for Pfaffian.")

    if not is_antisymmetric(a):
        raise ValueError("The Pfaffian does not support Non-antisymmetric matrices yet.")

    # Calculate normalization factor
    normalization = 1.0 / (2 ** n * factorial(n))

    indices = range(2 * n)
    result = fsum(
        sign * prod(a[sigma[2 * i]][sigma[2 * i + 1]] for i in range(n))
        for sigma, sign in spermutations(2 * n)
    )

    # Apply the normalization factor
    return normalization * result


def hfaffian(a):
    """Compute the hfaffian of a 2n x 2n symmetric matrix."""
    n = len(a) // 2

    if len(a) % 2 != 0:
        raise ValueError("Matrix must be 2n x 2n for hfaffian.")

    if not is_antisymmetric(a):
        raise ValueError("The Hfaffian does not support Non-antisymmetric matrices yet.")

    # Calculate normalization factor
    normalization = 1.0 / (2 ** n * factorial(n))

    indices = range(2 * n)
    result = fsum(
        prod(a[sigma[2 * i]][sigma[2 * i + 1]] for i in range(n))
        for sigma in permutations(indices)
    )

    # Apply the normalization factor
    return normalization * result


if __name__ == '__main__':
    from pprint import pprint as pp

    for a in (
            [
                [0, 1, -1, 2],
                [-1, 0, 3, -4],
                [1, -3, 0, 5],
                [-2, 4, -5, 0]],  # Example of an antisymmetric matrix for Pfaffian

            [
                [1, 2, 3, 4, 5, 6],
                [2, 7, 8, 9, 10, 11],
                [3, 8, 12, 13, 14, 15],
                [4, 9, 13, 16, 17, 18],
                [5, 10, 14, 17, 19, 20],
                [6, 11, 15, 18, 20, 21]],  # Example of a symmetric matrix for hfaffian
    ):
        print('')
        pp(a)
        if len(a) % 2 == 0:
            try:
                print('Pfaffian: %s' % pfaffian(a))
            except ValueError as e:
                print('Pfaffian Error:', e)
            try:
                print('Hfaffian: %s' % hfaffian(a))
            except ValueError as e:
                print('Hfaffian Error:', e)
        else:
            print('Matrix size must be even for Pfaffian and hfaffian.')
