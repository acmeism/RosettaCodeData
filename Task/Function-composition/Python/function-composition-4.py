from functools import reduce
from numbers import Number
import math


def main():
    '''Test'''

    f = composeList([
        lambda x: x / 2,
        succ,
        math.sqrt
    ])

    print(
        f(5)
    )


# GENERIC FUNCTIONS ---------------------------------------


# composeList :: [(a -> a)] -> (a -> a)
def composeList(fs):
    '''Composition, from right to left,
       of a series of functions.'''
    return lambda x: reduce(
        lambda a, f: f(a),
        fs[::-1],
        x
    )


# succ :: Enum a => a -> a
def succ(x):
    '''The successor of a value. For numeric types, (1 +).'''
    return 1 + x if isinstance(x, Number) else (
        chr(1 + ord(x))
    )


if __name__ == '__main__':
    main()
