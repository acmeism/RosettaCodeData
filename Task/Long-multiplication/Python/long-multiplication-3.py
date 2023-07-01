'''Long multiplication'''

from functools import reduce


def longmult(x, y):
    '''Long multiplication.'''
    return reduce(
        digitSum,
        polymul(digits(x), digits(y)), 0
    )


def digitSum(a, x):
    '''Left to right decimal digit summing.'''
    return a * 10 + x


def polymul(xs, ys):
    '''List of specific products.'''
    return map(
        lambda *vs: sum(filter(None, vs)),
        *[
            [0] * i + zs for i, zs in
            enumerate(mult_table(xs, ys))
        ]
    )


def mult_table(xs, ys):
    '''Rows of all products.'''
    return [[x * y for x in xs] for y in ys]


def digits(x):
    '''Digits of x as a list of integers.'''
    return [int(c) for c in str(x)]


if __name__ == '__main__':
    print(
        longmult(2 ** 64, 2 ** 64)
    )
