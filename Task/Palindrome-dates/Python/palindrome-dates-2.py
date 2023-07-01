'''Palindrome dates'''

from functools import reduce
from itertools import chain
from datetime import date


# palinDay :: Integer -> [ISO Date]
def palinDay(y):
    '''A possibly empty list containing the palindromic
       date for the given year, if such a date exists.
    '''
    [m, d] = [undigits(pair) for pair in chunksOf(2)(
        reversedDecimalDigits(y)
    )]
    return [] if (
        1 > m or m > 12 or 31 < d
    ) else validISODate((y, m, d))


# --------------------------TEST---------------------------
# main :: IO ()
def main():
    '''Count and samples of palindromic dates [2021..9999]
    '''
    palinDates = list(chain.from_iterable(
        map(palinDay, range(2021, 10000))
    ))
    for x in [
            'Count of palindromic dates [2021..9999]:',
            len(palinDates),
            '\nFirst 15:',
            '\n'.join(palinDates[0:15]),
            '\nLast 15:',
            '\n'.join(palinDates[-15:])
    ]:
        print(x)


# -------------------------GENERIC-------------------------

# Just :: a -> Maybe a
def Just(x):
    '''Constructor for an inhabited Maybe (option type) value.
       Wrapper containing the result of a computation.
    '''
    return {'type': 'Maybe', 'Nothing': False, 'Just': x}


# Nothing :: Maybe a
def Nothing():
    '''Constructor for an empty Maybe (option type) value.
       Empty wrapper returned where a computation is not possible.
    '''
    return {'type': 'Maybe', 'Nothing': True}


# chunksOf :: Int -> [a] -> [[a]]
def chunksOf(n):
    '''A series of lists of length n, subdividing the
       contents of xs. Where the length of xs is not evenly
       divible, the final list will be shorter than n.
    '''
    return lambda xs: reduce(
        lambda a, i: a + [xs[i:n + i]],
        range(0, len(xs), n), []
    ) if 0 < n else []


# reversedDecimalDigits :: Int -> [Int]
def reversedDecimalDigits(n):
    '''A list of the decimal digits of n,
       in reversed sequence.
    '''
    return unfoldr(
        lambda x: Nothing() if (
            0 == x
        ) else Just(divmod(x, 10))
    )(n)


# unDigits :: [Int] -> Int
def undigits(xs):
    '''An integer derived from a list of decimal digits
    '''
    return reduce(lambda a, x: a * 10 + x, xs, 0)


# unfoldr(lambda x: Just((x, x - 1)) if 0 != x else Nothing())(10)
# -> [10, 9, 8, 7, 6, 5, 4, 3, 2, 1]
# unfoldr :: (b -> Maybe (a, b)) -> b -> [a]
def unfoldr(f):
    '''Dual to reduce or foldr.
       Where catamorphism reduces a list to a summary value,
       the anamorphic unfoldr builds a list from a seed value.
       As long as f returns Just(a, b), a is prepended to the list,
       and the residual b is used as the argument for the next
       application of f.
       When f returns Nothing, the completed list is returned.
    '''
    def go(v):
        xr = v, v
        xs = []
        while True:
            mb = f(xr[0])
            if mb.get('Nothing'):
                return xs
            else:
                xr = mb.get('Just')
                xs.append(xr[1])
        return xs
    return go


# validISODate :: (Int, Int, Int) -> [Date]
def validISODate(ymd):
    '''A possibly empty list containing the
       ISO8601 string for a date, if that date exists.
    '''
    try:
        return [date(*ymd).isoformat()]
    except ValueError:
        return []


# MAIN ---
if __name__ == '__main__':
    main()
