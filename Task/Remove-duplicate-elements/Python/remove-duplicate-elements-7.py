# nubByEq :: (a -> a -> Bool) -> [a] -> [a]
def nubByEq(eq, xs):
    def go(yys, xxs):
        if yys:
            y = yys[0]
            ys = yys[1:]
            return go(ys, xxs) if (
                elemBy(eq, y, xxs)
            ) else (
                [y] + go(ys, [y] + xxs)
            )
        else:
            return []
    return go(xs, [])


# elemBy :: (a -> a -> Bool) -> a -> [a] -> Bool
def elemBy(eq, x, xs):
    if xs:
        return eq(x, xs[0]) or elemBy(eq, x, xs[1:])
    else:
        return False


xs = [
    'apple', 'apple',
    'ampersand', 'aPPLE', 'Apple',
    'orange', 'ORANGE', 'Orange', 'orange', 'apple'
]
for eq in [
    lambda a, b: a == b,                   # default case sensitive uniqueness
    lambda a, b: a.lower() == b.lower(),   # case-insensitive uniqueness
    lambda a, b: a[0] == b[0],             # unique first char (case-sensitive)
    lambda a, b: a[0].lower() == b[0].lower(),   # unique first char (any case)
]:
    print (
        nubByEq(eq, xs)
    )
