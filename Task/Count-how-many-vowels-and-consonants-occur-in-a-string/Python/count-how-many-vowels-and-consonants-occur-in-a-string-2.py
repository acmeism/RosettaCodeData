'''Total and individual counts of vowel and consonant instances'''

from functools import reduce


# vowelAndConsonantCounts :: String ->
#   ([(Char, Int)], [(Char, Int)])
def vowelAndConsonantCounts(s):
    '''The sorted character counts for each
       vowel seen in the string, tupled with the sorted
       character counts for each consonant seen.
    '''
    return both(sorted)(
        partition(lambda kv: isVowel(kv[0]))([
            (k, v) for (k, v) in list(charCounts(s).items())
            if k.isalpha()
        ])
    )


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''Total and individual counts for a given string'''

    vs, cs = vowelAndConsonantCounts(
        "Forever Fortran 2018 programming language"
    )
    nv, nc = valueSum(vs), valueSum(cs)
    print(f'{nv + nc} "vowels and consonants"\n')

    print(f'\t{nv} characters drawn from {len(vs)} vowels:')
    print(showCharCounts(vs))
    print(f'\n\t{nc} characters drawn from {len(cs)} consonants:')
    print(showCharCounts(cs))


# ----------------------- DISPLAY ------------------------

# showCharCounts :: [(Char, Int)] -> String
def showCharCounts(kvs):
    '''Indented listing of character frequencies.
    '''
    return '\n'.join(['\t\t' + repr(kv) for kv in kvs])


# ----------------------- GENERIC ------------------------

# both :: (a -> b) -> (a,  a) -> (b,  b)
def both(f):
    '''The same function applied to both
       values of a tuple.
    '''
    def go(ab):
        return f(ab[0]), f(ab[1])
    return go


# charCount :: String -> Dict
def charCounts(s):
    '''A dictionary of characters seen,
       with their frequencies.
    '''
    def go(dct, c):
        dct.update({c: 1 + dct.get(c, 0)})
        return dct

    return reduce(go, list(s), dict())


# isVowel :: Char -> Bool
def isVowel(c):
    '''True if the character is an Anglo-Saxon vowel'''
    return c in "aeiouAEIOU"


# partition :: (a -> Bool) -> [a] -> ([a], [a])
def partition(p):
    '''The pair of lists of those elements in xs
       which respectively do, and don't
       satisfy the predicate p.
    '''
    def go(a, x):
        ts, fs = a
        return (ts + [x], fs) if p(x) else (ts, fs + [x])
    return lambda xs: reduce(go, xs, ([], []))


# valueSum :: [(String, Int)] -> Int
def valueSum(kvs):
    '''The sum of values in a [(key, value)] list'''
    return sum(kv[1] for kv in kvs)


# MAIN ---
if __name__ == '__main__':
    main()
