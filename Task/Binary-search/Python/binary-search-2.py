# findIndexBinary :: (a -> Ordering) -> [a] -> Maybe Int
def findIndexBinary(p):
    def isFound(bounds):
        (lo, hi) = bounds
        return lo > hi or 0 == hi

    def half(xs):
        def choice(lh):
            (lo, hi) = lh
            mid = (lo + hi) // 2
            cmpr = p(xs[mid])
            return (lo, mid - 1) if cmpr < 0 else (
                (1 + mid, hi) if cmpr > 0 else (
                    mid, 0
                )
            )
        return lambda bounds: choice(bounds)

    def go(xs):
        (lo, hi) = until(isFound)(
            half(xs)
        )((0, len(xs) - 1)) if xs else None
        return None if 0 != hi else lo

    return lambda xs: go(xs)


# COMPARISON CONSTRUCTORS ---------------------------------

# compare :: a -> a -> Ordering
def compare(a):
    '''Simple comparison of x and y -> LT|EQ|GT'''
    return lambda b: -1 if a < b else (1 if a > b else 0)


# byKV :: (a -> b) -> a -> a -> Ordering
def byKV(f):
    '''Property accessor function -> target value -> x -> LT|EQ|GT'''
    def go(v, x):
        fx = f(x)
        return -1 if v < fx else 1 if v > fx else 0
    return lambda v: lambda x: go(v, x)


# TESTS ---------------------------------------------------
def main():

    # BINARY SEARCH FOR WORD IN AZ-SORTED LIST

    mb1 = findIndexBinary(compare('iota'))(
        # Sorted AZ
        ['alpha', 'beta', 'delta', 'epsilon', 'eta', 'gamma', 'iota',
         'kappa', 'lambda', 'mu', 'theta', 'zeta']
    )

    print (
        'Not found' if None is mb1 else (
            'Word found at index ' + str(mb1)
        )
    )

    # BINARY SEARCH FOR WORD OF GIVEN LENGTH (IN WORD-LENGTH SORTED LIST)

    mb2 = findIndexBinary(byKV(len)(7))(
        # Sorted by rising length
        ['mu', 'eta', 'beta', 'iota', 'zeta', 'alpha', 'delta', 'gamma',
         'kappa', 'theta', 'lambda', 'epsilon']
    )

    print (
        'Not found' if None is mb2 else (
            'Word of given length found at index ' + str(mb2)
        )
    )


# GENERIC -------------------------------------------------

# until :: (a -> Bool) -> (a -> a) -> a -> a
def until(p):
    def go(f, x):
        v = x
        while not p(v):
            v = f(v)
        return v
    return lambda f: lambda x: go(f, x)


if __name__ == '__main__':
    main()
