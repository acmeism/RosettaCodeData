'''Instance-specific character replacement rules'''

from functools import reduce


# nthInstanceReplaced :: Dict Char [(None | Char)] ->
# String -> String
def nthInstanceReplaced(ruleMap):
    def go(a, c):
        ds = a.get(c, None)
        return (
            dict(a, **{c: ds[1:]}),
            ds[0] or c
        ) if ds else (a, c)

    return lambda s: ''.join(
        mapAccumL(go)(ruleMap)(s)[1]
    )


# ------------------------- TEST -------------------------
def main():
    '''Rule-set applied to a given string.'''

    print(
        nthInstanceReplaced({
            'a': ['A', 'B', None, 'C', 'D'],
            'b': ['E'],
            'r': [None, 'F']
        })(
            "abracadabra"
        )
    )


# ----------------------- GENERIC ------------------------

# mapAccumL :: (acc -> x -> (acc, y)) ->
# acc -> [x] -> (acc, [y])
def mapAccumL(f):
    '''A tuple of an accumulation and a map
       with accumulation from left to right.
    '''
    def go(a, x):
        return second(lambda v: a[1] + [v])(
            f(a[0], x)
        )
    return lambda acc: lambda xs: reduce(
        go, xs, (acc, [])
    )


# second :: (a -> b) -> ((c, a) -> (c, b))
def second(f):
    '''A simple function lifted to a function over a tuple,
       with f applied only to the second of two values.
    '''
    return lambda xy: (xy[0], f(xy[1]))


# MAIN ---
if __name__ == '__main__':
    main()
