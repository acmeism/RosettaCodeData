#!/usr/bin/env python

def digits(x):
    return [int(c) for c in str(x)]

def mult_table(xs, ys):
    return [[x * y for x in xs] for y in ys]

def polymul(xs, ys):
    return map(lambda *vs: sum(filter(None, vs)),
               *[[0] * i + zs for i, zs in enumerate(mult_table(xs, ys))])

def longmult(x, y):
    result = 0
    for v in polymul(digits(x), digits(y)):
        result = result * 10 + v
    return result

if __name__ == "__main__":
    print longmult(2**64, 2**64)
