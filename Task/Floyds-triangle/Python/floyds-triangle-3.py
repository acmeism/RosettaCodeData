'''Floyd triangle in terms of concatMap'''

from itertools import chain


# floyd :: Int -> [[Int]]
def floyd(n):
    '''n rows of a Floyd triangle.'''
    def f(i):
        return [
            enumFromTo(i * pred(i) // 2 + 1)(
                i * succ(i) // 2
            )
        ]
    return concatMap(f)(enumFromTo(1)(n))


# main :: IO ()
def main():
    '''Test'''
    print(unlines(
        map(str, floyd(5))
    ))


# GENERIC FUNCTIONS ---------------------------------------


# enumFromTo :: (Int, Int) -> [Int]
def enumFromTo(m):
    '''Integer enumeration from m to n.'''
    return lambda n: list(range(m, 1 + n))


# concatMap :: (a -> [b]) -> [a] -> [b]
def concatMap(f):
    '''Concatenated list over which a function has been mapped.
       The list monad can be derived by using a function f which
       wraps its output in a list,
       (using an empty list to represent computational failure).'''
    return lambda xs: list(
        chain.from_iterable(
            map(f, xs)
        )
    )


# pred ::  Enum a => a -> a
def pred(x):
    '''The predecessor of a value. For numeric types, (- 1).'''
    return x - 1 if isinstance(x, int) else (
        chr(ord(x) - 1)
    )


# succ :: Enum a => a -> a
def succ(x):
    '''The successor of a value. For numeric types, (1 +).'''
    return 1 + x if isinstance(x, int) else (
        chr(1 + ord(x))
    )


# unlines :: [String] -> String
def unlines(xs):
    '''A single string derived by the intercalation
       of a list of strings with the newline character.'''
    return '\n'.join(xs)


if __name__ == '__main__':
    main()
