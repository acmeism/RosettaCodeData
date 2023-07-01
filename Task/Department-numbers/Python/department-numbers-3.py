'''Department numbers'''

from operator import ne


# options :: Int -> Int -> Int -> [(Int, Int, Int)]
def options(lo, hi, total):
    '''Eligible triples.'''
    ds = enumFromTo(lo)(hi)
    return [
        (x, y, z)
        for x in filter(even, ds)
        for y in filter(curry(ne)(x), ds)
        for z in [total - (x + y)]
        if y != z and lo <= z <= hi
    ]


# Or with less tightly-constrained generation,
# and more winnowing work downstream:

# options2 :: Int -> Int -> Int -> [(Int, Int, Int)]
def options2(lo, hi, total):
    '''Eligible triples.'''
    ds = enumFromTo(lo)(hi)
    return [
        (x, y, z)
        for x in ds
        for y in ds
        for z in [total - (x + y)]
        if even(x) and y not in [x, z] and lo <= z <= hi
    ]


# GENERIC -------------------------------------------------


# curry :: ((a, b) -> c) -> a -> b -> c
def curry(f):
    '''A curried function derived
       from an uncurried function.'''
    return lambda a: lambda b: f(a, b)


# enumFromTo :: (Int, Int) -> [Int]
def enumFromTo(m):
    '''Integer enumeration from m to n.'''
    return lambda n: list(range(m, 1 + n))


# even :: Int -> Bool
def even(x):
    '''True if x is an integer
       multiple of two.'''
    return 0 == x % 2


# unlines :: [String] -> String
def unlines(xs):
    '''A single string derived by the intercalation
       of a list of strings with the newline character.'''
    return '\n'.join(xs)


# TEST ----------------------------------------------------
# main :: IO ()
def main():
    '''Test'''

    xs = options(1, 7, 12)
    print(('Police', 'Sanitation', 'Fire'))
    print(unlines(map(str, xs)))
    print('\nNo. of options: ' + str(len(xs)))


if __name__ == '__main__':
    main()
