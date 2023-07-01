'''Multiplication table

   1. by list comprehension (mulTable ),
   2. by list monad.        (mulTable2)'''

from itertools import chain


# mulTable :: Int -> String
def mulTable(n):
    '''A multiplication table of dimension n,
       without redundant entries beneath
       the diagonal of squares.'''

    # colWidth :: Int
    colWidth = len(str(n * n))

    # pad :: String -> String
    def pad(s):
        return s.rjust(colWidth, ' ')

    xs = enumFromTo(1)(n)
    return unlines([
        pad(str(y) + ':') + unwords([
            pad(str(x * y) if x >= y else '')
            for x in xs
        ]) for y in xs
    ])


# mulTable2 :: Int -> String
def mulTable2(n):
    '''Identical to mulTable above,
       but the list comprehension is directly
       desugared to an equivalent list monad expression.'''

    # colWidth :: Int
    colWidth = len(str(n * n))

    # pad :: String -> String
    def pad(s):
        return s.rjust(colWidth, ' ')

    xs = enumFromTo(1)(n)
    return unlines(
        bind(xs)(lambda y: [
            pad(str(y) + ':') + unwords(
                bind(xs)(lambda x: [
                    pad(str(x * y) if x >= y else '')
                ])
            )
        ])
    )


# TEST ----------------------------------------------------
# main :: IO ()
def main():
    '''Test'''

    for s, f in [
            ('list comprehension', mulTable),
            ('list monad', mulTable2)
    ]:
        print(
            'By ' + s + ' (' + f.__name__ + '):\n\n',
            f(12).strip() + '\n'
        )


# GENERIC -------------------------------------------------

# bind (>>=) :: [a] -> (a -> [b]) -> [b]
def bind(xs):
    '''The injection operator for the list monad.
       Equivalent to concatMap with its arguments flipped.'''
    return lambda f: list(
        chain.from_iterable(
            map(f, xs)
        )
    )


# enumFromTo :: (Int, Int) -> [Int]
def enumFromTo(m):
    '''Integer enumeration from m to n.'''
    return lambda n: list(range(m, 1 + n))


# unlines :: [String] -> String
def unlines(xs):
    '''A newline-delimited string derived from a list of lines.'''
    return '\n'.join(xs)


# unwords :: [String] -> String
def unwords(xs):
    '''A space-delimited string derived from a list of words.'''
    return ' '.join(xs)


if __name__ == '__main__':
    main()
