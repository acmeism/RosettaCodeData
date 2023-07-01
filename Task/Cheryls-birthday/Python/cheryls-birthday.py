'''Cheryl's Birthday'''

from itertools import groupby
from re import split


# main :: IO ()
def main():
    '''Derivation of the date.'''

    month, day = 0, 1
    print(
        # (3 :: A "Then I also know")
        # (A's month contains only one remaining day)
        uniquePairing(month)(
            # (2 :: B "I know now")
            # (B's day is paired with only one remaining month)
            uniquePairing(day)(
                # (1 :: A "I know that Bernard does not know")
                # (A's month is not among those with unique days)
                monthsWithUniqueDays(False)([
                    # 0 :: Cheryl's list:
                    tuple(x.split()) for x in
                    split(
                        ', ',
                        'May 15, May 16, May 19, ' +
                        'June 17, June 18, ' +
                        'July 14, July 16, ' +
                        'Aug 14, Aug 15, Aug 17'
                    )
                ])
            )
        )
    )


# ------------------- QUERY FUNCTIONS --------------------

# monthsWithUniqueDays :: Bool -> [(Month, Day)] -> [(Month, Day)]
def monthsWithUniqueDays(blnInclude):
    '''The subset of months with (or without) unique days.
    '''
    def go(xs):
        month, day = 0, 1
        months = [fst(x) for x in uniquePairing(day)(xs)]
        return [
            md for md in xs
            if blnInclude or not (md[month] in months)
        ]
    return go


# uniquePairing :: DatePart -> [(Month, Day)] -> [(Month, Day)]
def uniquePairing(i):
    '''Subset of months (or days) with a unique intersection.
    '''
    def go(xs):
        def inner(md):
            dct = md[i]
            uniques = [
                k for k in dct.keys()
                if 1 == len(dct[k])
            ]
            return [tpl for tpl in xs if tpl[i] in uniques]
        return inner
    return ap(bindPairs)(go)


# bindPairs :: [(Month, Day)] ->
# ((Dict String [String], Dict String [String])
# -> [(Month, Day)]) -> [(Month, Day)]
def bindPairs(xs):
    '''List monad injection operator for lists
       of (Month, Day) pairs.
    '''
    return lambda f: f(
        (
            dictFromPairs(xs),
            dictFromPairs(
                [(b, a) for (a, b) in xs]
            )
        )
    )


# dictFromPairs :: [(Month, Day)] -> Dict Text [Text]
def dictFromPairs(xs):
    '''A dictionary derived from a list of
       month day pairs.
    '''
    return {
        k: [snd(x) for x in m] for k, m in groupby(
            sorted(xs, key=fst), key=fst
        )
    }


# ----------------------- GENERIC ------------------------

# ap :: (a -> b -> c) -> (a -> b) -> a -> c
def ap(f):
    '''Applicative instance for functions.
    '''
    def go(g):
        def fxgx(x):
            return f(x)(
                g(x)
            )
        return fxgx
    return go


# fst :: (a, b) -> a
def fst(tpl):
    '''First component of a pair.
    '''
    return tpl[0]


# snd :: (a, b) -> b
def snd(tpl):
    '''Second component of a pair.
    '''
    return tpl[1]


if __name__ == '__main__':
    main()
