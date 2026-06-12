'''Wordle comparison'''

from functools import reduce
from operator import add


# wordleScore :: String -> String -> [Int]
def wordleScore(target, guess):
    '''A sequence of integers scoring characters
       in the guess:
       2 for correct character and position
       1 for a character which is elsewhere in the target
       0 for for character not seen in the target.
    '''
    return mapAccumL(amber)(
        *first(charCounts)(
            mapAccumL(green)(
                [], zip(target, guess)
            )
        )
    )[1]


# green :: String -> (Char, Char) -> (String, (Char, Int))
def green(residue, tg):
    '''The existing residue of unmatched characters, tupled
       with a character score of 2 if the target character
       and guess character match.
       Otherwise, a residue (extended by the unmatched
       character) tupled with a character score of 0.
    '''
    t, g = tg
    return (residue, (g, 2)) if t == g else (
        [t] + residue, (g, 0)
    )


# amber :: Dict -> (Char, Int) -> (Dict, Int)
def amber(tally, cn):
    '''An adjusted tally of the counts of unmatched
       of remaining unmatched characters, tupled with
       a 1 if the character was in the remaining tally
       (now decremented) and otherwise a 0.
    '''
    c, n = cn
    return (tally, 2) if 2 == n else (
        adjust(
            lambda x: x - 1,
            c, tally
        ),
        1
    ) if 0 < tally.get(c, 0) else (tally, 0)


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''Scores for a set of (Target, Guess) pairs.
    '''
    print(' -> '.join(['Target', 'Guess', 'Scores']))
    print()
    print(
        '\n'.join([
            wordleReport(*tg) for tg in [
                ("ALLOW", "LOLLY"),
                ("CHANT", "LATTE"),
                ("ROBIN", "ALERT"),
                ("ROBIN", "SONIC"),
                ("ROBIN", "ROBIN"),
                ("BULLY", "LOLLY"),
                ("ADAPT", "SÅLÅD"),
                ("Ukraine", "Ukraíne"),
                ("BBAAB", "BBBBBAA"),
                ("BBAABBB", "AABBBAA")
            ]
        ])
    )


# wordleReport :: String -> String -> String
def wordleReport(target, guess):
    '''Either a message, if target or guess are other than
       five characters long, or a color-coded wordle score
       for each character in the guess.
    '''
    scoreName = {2: 'green', 1: 'amber', 0: 'gray'}

    if 5 != len(target):
        return f'{target}: Expected 5 character target.'
    elif 5 != len(guess):
        return f'{guess}: Expected 5 character guess.'
    else:
        scores = wordleScore(target, guess)
        return ' -> '.join([
            target, guess, repr(scores),
            ' '.join([
                scoreName[n] for n in scores
            ])
        ])


# ----------------------- GENERIC ------------------------

# adjust :: (a -> a) -> Key -> Dict -> Dict
def adjust(f, k, dct):
    '''A new copy of the Dict, in which any value for
       the given key has been updated by application of
       f to the existing value.
    '''
    return dict(
        dct,
        **{k: f(dct[k]) if k in dct else None}
    )


# charCounts :: String -> Dict Char Int
def charCounts(s):
    '''A dictionary of the individual characters in s,
       with the frequency of their occurrence.
    '''
    return reduce(
        lambda a, c: insertWith(add)(c)(1)(a),
        list(s),
        {}
    )


# first :: (a -> b) -> ((a, c) -> (b, c))
def first(f):
    '''A simple function lifted to a function over a tuple,
       with f applied only the first of two values.
    '''
    return lambda xy: (f(xy[0]), xy[1])


# insertWith :: Ord k => (a -> a -> a) ->
#   k -> a -> Map k a -> Map k a
def insertWith(f):
    '''A new dictionary updated with a (k, f(v)(x)) pair.
       Where there is no existing v for k, the supplied
       x is used directly.
    '''
    return lambda k: lambda x: lambda dct: dict(
        dct,
        **{k: f(dct[k], x) if k in dct else x}
    )


# mapAccumL :: (acc -> x -> (acc, y)) -> acc ->
# [x] -> (acc, [y])
def mapAccumL(f):
    '''A tuple of an accumulation and a map
       with accumulation from left to right.
    '''
    def nxt(a, x):
        return second(lambda v: a[1] + [v])(
            f(a[0], x)
        )
    return lambda acc, xs: reduce(
        nxt, xs, (acc, [])
    )


# second :: (a -> b) -> ((c, a) -> (c, b))
def second(f):
    '''A simple function lifted to a function over a tuple,
       with f applied only to the second of two values.
    '''
    return lambda xy: (xy[0], f(xy[1]))


# MAIN ---
if __name__ == '__main__':
    main()
