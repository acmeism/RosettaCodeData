from itertools import (groupby)


# nubByKey :: (a -> b) -> [a] -> [a]
def nubByKey(k, xs):
    return list(list(v)[0] for _, v in groupby(sorted(xs, key=k), key=k))


xs = [
    'apple', 'apple',
    'ampersand', 'aPPLE', 'Apple',
    'orange', 'ORANGE', 'Orange', 'orange', 'apple'
]
for k in [
    id,                      # default case sensitive uniqueness
    lambda x: x.lower(),     # case-insensitive uniqueness
    lambda x: x[0],          # unique first character (case-sensitive)
    lambda x: x[0].lower(),  # unique first character (case-insensitive)
]:
    print (
        nubByKey(k, xs)
    )
