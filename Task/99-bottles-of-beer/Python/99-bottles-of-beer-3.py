'''99 Units of Disposable Asset'''


from itertools import chain


# main :: IO ()
def main():
    '''Modalised asset dispersal procedure.'''

    # localisation :: (String, String, String)
    localisation = (
        'on the wall',
        'Take one down, pass it around',
        'Better go to the store to buy some more'
    )

    print(unlines(map(
        incantation(localisation),
        enumFromThenTo(99)(98)(0)
    )))


# incantation :: (String, String, String) -> Int -> String
def incantation(localisation):
    '''Versification of asset disposal
       and inventory update.'''

    location, distribution, solution = localisation

    def inventory(n):
        return unwords([asset(n), location])
    return lambda n: solution if 0 == n else (
        unlines([
            inventory(n),
            asset(n),
            distribution,
            inventory(pred(n))
        ])
    )


# asset :: Int -> String
def asset(n):
    '''Quantified asset.'''
    def suffix(n):
        return [] if 1 == n else 's'
    return unwords([
        str(n),
        concat(reversed(concat(cons(suffix(n))(["elttob"]))))
    ])


# GENERIC -------------------------------------------------

# concat :: [[a]] -> [a]
# concat :: [String] -> String
def concat(xxs):
    '''The concatenation of all the elements in a list.'''
    xs = list(chain.from_iterable(xxs))
    unit = '' if isinstance(xs, str) else []
    return unit if not xs else (
        ''.join(xs) if isinstance(xs[0], str) else xs
    )


# cons :: a -> [a] -> [a]
def cons(x):
    '''Construction of a list from x as head,
       and xs as tail.'''
    return lambda xs: [x] + xs if (
        isinstance(xs, list)
    ) else chain([x], xs)


# enumFromThenTo :: Int -> Int -> Int -> [Int]
def enumFromThenTo(m):
    '''Integer values enumerated from m to n
       with a step defined by nxt-m.'''
    def go(nxt, n):
        d = nxt - m
        return list(range(m, d + n, d))
    return lambda nxt: lambda n: (
        go(nxt, n)
    )


# pred ::  Enum a => a -> a
def pred(x):
    '''The predecessor of a value. For numeric types, (- 1).'''
    return x - 1 if isinstance(x, int) else (
        chr(ord(x) - 1)
    )


# unlines :: [String] -> String
def unlines(xs):
    '''A single string derived by the intercalation
       of a list of strings with the newline character.'''
    return '\n'.join(xs)


# unwords :: [String] -> String
def unwords(xs):
    '''A space-separated string derived from
       a list of words.'''
    return ' '.join(xs)


if __name__ == '__main__':
    main()
