'''Happy numbers'''

from itertools import islice


# main :: IO ()
def main():
    '''Test'''
    print(
        take(8)(
            happyNumbers()
        )
    )


# happyNumbers :: Gen [Int]
def happyNumbers():
    '''Generator :: non-finite stream of happy numbers.'''
    x = 1
    while True:
        x = until(isHappy)(succ)(x)
        yield x
        x = succ(x)


# isHappy :: Int -> Bool
def isHappy(n):
    '''Happy number sequence starting at n reaches 1 ?'''
    seen = set()

    # p :: Int -> Bool
    def p(x):
        if 1 == x or x in seen:
            return True
        else:
            seen.add(x)
            return False

    # f :: Int -> Int
    def f(x):
        return sum(int(d)**2 for d in str(x))

    return 1 == until(p)(f)(n)


# GENERIC -------------------------------------------------

# succ :: Int -> Int
def succ(x):
    '''The successor of an integer.'''
    return 1 + x


# take :: Int -> [a] -> [a]
# take :: Int -> String -> String
def take(n):
    '''The prefix of xs of length n,
       or xs itself if n > length xs.'''
    return lambda xs: (
        xs[0:n]
        if isinstance(xs, list)
        else list(islice(xs, n))
    )


# until :: (a -> Bool) -> (a -> a) -> a -> a
def until(p):
    '''The result of repeatedly applying f until p holds.
       The initial seed value is x.'''
    def go(f, x):
        v = x
        while not p(v):
            v = f(v)
        return v
    return lambda f: lambda x: go(f, x)


if __name__ == '__main__':
    main()
