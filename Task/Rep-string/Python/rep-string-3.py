'''Rep-strings'''

from itertools import (accumulate, chain, cycle, islice)


# repCycles :: String -> [String]
def repCycles(s):
    '''Repeated sequences of characters in s.'''
    n = len(s)
    cs = list(s)

    return [
        x for x in
        tail(inits(take(n // 2)(s)))
        if cs == take(n)(cycle(x))
    ]


# TEST ----------------------------------------------------
# main :: IO ()
def main():
    '''Tests - longest cycle (if any) in each string.'''
    print(
        fTable('Longest cycles:\n')(repr)(
            lambda xs: ''.join(xs[-1]) if xs else '(none)'
        )(repCycles)([
            '1001110011',
            '1110111011',
            '0010010010',
            '1010101010',
            '1111111111',
            '0100101101',
            '0100100',
            '101',
            '11',
            '00',
            '1',
        ])
    )


# GENERIC -------------------------------------------------

# inits :: [a] -> [[a]]
def inits(xs):
    '''all initial segments of xs, shortest first.'''
    return accumulate(chain([[]], xs), lambda a, x: a + [x])


# tail :: [a] -> [a]
# tail :: Gen [a] -> [a]
def tail(xs):
    '''The elements following the head of a
       (non-empty) list or generator stream.'''
    if isinstance(xs, list):
        return xs[1:]
    else:
        list(islice(xs, 1))  # First item dropped.
        return xs


# take :: Int -> [a] -> [a]
# take :: Int -> String -> String
def take(n):
    '''The prefix of xs of length n,
       or xs itself if n > length xs.'''
    return lambda xs: (
        xs[0:n]
        if isinstance(xs, (list, tuple))
        else list(islice(xs, n))
    )


# OUTPUT FORMATTING ---------------------------------------

# fTable :: String -> (a -> String) ->
#                     (b -> String) -> (a -> b) -> [a] -> String
def fTable(s):
    '''Heading -> x display function ->
                 fx display function ->
          f -> value list -> tabular string.
    '''
    def go(xShow, fxShow, f, xs):
        ys = [xShow(x) for x in xs]
        w = max(map(len, ys))
        return s + '\n' + '\n'.join(map(
            lambda x, y: y.rjust(w, ' ') + ' -> ' + fxShow(f(x)),
            xs, ys
        ))
    return lambda xShow: lambda fxShow: lambda f: lambda xs: go(
        xShow, fxShow, f, xs
    )


# MAIN ---
if __name__ == '__main__':
    main()
