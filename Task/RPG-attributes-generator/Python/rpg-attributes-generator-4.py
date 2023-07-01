'''RPG Attributes Generator'''

from itertools import islice
from random import randint
from operator import eq


# heroes :: Gen IO [(Int, Int, Int, Int, Int, Int)]
def heroes(p):
    '''Non-finite list of heroes matching
       the requirements of predicate p.
    '''
    while True:
        yield tuple(
            until(p)(character)([])
        )


# character :: () -> IO [Int]
def character(_):
    '''A random character with six
       integral attributes.
    '''
    return [
        sum(sorted(map(
            randomRInt(1)(6),
            enumFromTo(1)(4)
        ))[1:])
        for _ in enumFromTo(1)(6)
    ]


# ------------------------- TEST --------------------------
# main :: IO ()
def main():
    '''Test :: Sample of 10'''

    # seventyFivePlusWithTwo15s :: [Int] -> Bool
    def seventyFivePlusIncTwo15s(xs):
        '''Sums to 75 or more,
           and includes at least two 15s.
        '''
        return 75 <= sum(xs) and (
            1 < len(list(filter(curry(eq)(15), xs)))
        )

    print('A sample of 10:\n')
    print(unlines(
        str(sum(x)) + ' -> ' + str(x) for x
        in take(10)(heroes(
            seventyFivePlusIncTwo15s
        ))
    ))


# ------------------------- GENERIC -------------------------

# curry :: ((a, b) -> c) -> a -> b -> c
def curry(f):
    '''A curried function derived
       from an uncurried function.
    '''
    return lambda x: lambda y: f(x, y)


# enumFromTo :: Int -> Int -> [Int]
def enumFromTo(m):
    '''Enumeration of integer values [m..n]'''
    return lambda n: range(m, 1 + n)


# randomRInt :: Int -> Int -> IO () -> Int
def randomRInt(m):
    '''The return value of randomRInt is itself
       a function. The returned function, whenever
       called, yields a a new pseudo-random integer
       in the range [m..n].
    '''
    return lambda n: lambda _: randint(m, n)


# take :: Int -> [a] -> [a]
# take :: Int -> String -> String
def take(n):
    '''The prefix of xs of length n,
       or xs itself if n > length xs.
    '''
    return lambda xs: (
        xs[0:n]
        if isinstance(xs, (list, tuple))
        else list(islice(xs, n))
    )


# unlines :: [String] -> String
def unlines(xs):
    '''A single string formed by the intercalation
       of a list of strings with the newline character.
    '''
    return '\n'.join(xs)


# until :: (a -> Bool) -> (a -> a) -> a -> a
def until(p):
    '''The result of repeatedly applying f until p holds.
       The initial seed value is x.
    '''
    def go(f, x):
        v = x
        while not p(v):
            v = f(v)
        return v
    return lambda f: lambda x: go(f, x)


if __name__ == '__main__':
    main()
