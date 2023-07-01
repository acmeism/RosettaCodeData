from functools import reduce
from math import sqrt


def compose(*fs):
    '''Composition, from right to left,
       of an arbitrary number of functions.
    '''
    def go(f, g):
        return lambda x: f(g(x))

    return reduce(go, fs, lambda x: x)


# ------------------------- TEST -------------------------
def main():
    '''Composition of three functions.'''

    f = compose(
        half,
        succ,
        sqrt
    )

    print(
        f(5)
    )


# ----------------------- GENERAL ------------------------
def half(n):
    return n / 2


def succ(n):
    return 1 + n


if __name__ == '__main__':
    main()
