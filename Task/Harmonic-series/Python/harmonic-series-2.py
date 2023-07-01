'''Harmonic series'''

from fractions import Fraction
from itertools import accumulate, count, islice
from operator import add


# harmonic :: [Fraction]
def harmonic():
    '''Non finite stream of the terms
       of the Harmonic series.
    '''
    return accumulate(
        (1 / Fraction(x) for x in count(1)),
        add
    )


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''Tests of the harmonic series function'''

    print('First 20 terms of the harmonic series:')
    print('\n'.join([
        showFraction(nd) for nd in islice(harmonic(), 20)
    ]))

    print('\n100th term:')
    print(
        showFraction(
            next(islice(harmonic(), 99, None))
        )
    )

    print('')
    print(
        'One-based indices of terms above threshold values:'
    )
    indexedHarmonic = enumerate(harmonic())
    print('\n'.join([
        next(
            showFirstLimit(n)(x) for x
            in indexedHarmonic if n < x[1]
        ) for n in range(1, 1 + 10)
    ]))


# ------------------ DISPLAY FORMATTING ------------------

# showFraction :: Fraction -> String
def showFraction(nd):
    '''String representation of the fraction nd.
    '''
    n, d = nd.as_integer_ratio()

    return f'{n} / {d}'


# showFirstLimit :: Int -> (Int, Fraction) -> String
def showFirstLimit(n):
    '''Report of 1-based index of first term
       with a value over n
    '''
    def go(indexedFraction):
        i = indexedFraction[0]

        return f'Term {1 + i} is the first above {n}'

    return go


# MAIN ---
if __name__ == '__main__':
    main()
