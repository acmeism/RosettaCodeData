'''Longest palindromic substrings'''


# longestPalindrome :: String -> ([String], Int)
def longestPalindromes(s):
    '''All palindromes of the maximal length
       drawn from a case-flattened copy of
       the given string, tupled with the
       maximal length.
       Non-alphanumerics are included here.
    '''
    k = s.lower()
    palindromes = [
        palExpansion(k)(ab) for ab
        in palindromicNuclei(k)
    ]
    maxLength = max([
        len(x) for x in palindromes
    ]) if palindromes else 1
    return (
        [
            x for x in palindromes if maxLength == len(x)
        ] if palindromes else list(s),
        maxLength
    ) if s else ([], 0)


# palindromicNuclei :: String -> [(Int, Int)]
def palindromicNuclei(s):
    '''Ranges of all the 2 or 3 character
       palindromic nuclei in s.
    '''
    cs = list(s)
    return [
        # Two-character nuclei.
        (i, 1 + i) for (i, (a, b))
        in enumerate(zip(cs, cs[1:]))
        if a == b
    ] + [
        # Three-character nuclei.
        (i, 2 + i) for (i, (a, b, c))
        in enumerate(zip(cs, cs[1:], cs[2:]))
        if a == c
    ]


# palExpansion :: String -> (Int, Int) -> String
def palExpansion(s):
    '''Full expansion of the palindromic
       nucleus with the given range in s.
    '''
    iEnd = len(s) - 1

    def limit(ij):
        i, j = ij
        return 0 == i or iEnd == j or s[i-1] != s[j+1]

    def expansion(ij):
        i, j = ij
        return (i - 1, 1 + j)

    def go(ij):
        ab = until(limit)(expansion)(ij)
        return s[ab[0]:ab[1] + 1]
    return go


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''Longest palindromic substrings'''
    print(
        fTable(main.__doc__ + ':\n')(repr)(repr)(
            longestPalindromes
        )([
            'three old rotators',
            'never reverse',
            'stable was I ere I saw elbatrosses',
            'abracadabra',
            'drome',
            'the abbatial palace',
            ''
        ])
    )


# ----------------------- GENERIC ------------------------

# until :: (a -> Bool) -> (a -> a) -> a -> a
def until(p):
    '''The result of repeatedly applying f until p holds.
       The initial seed value is x.
    '''
    def go(f):
        def g(x):
            v = x
            while not p(v):
                v = f(v)
            return v
        return g
    return go


# ---------------------- FORMATTING ----------------------

# fTable :: String -> (a -> String) ->
# (b -> String) -> (a -> b) -> [a] -> String
def fTable(s):
    '''Heading -> x display function -> fx display function ->
       f -> xs -> tabular string.
    '''
    def gox(xShow):
        def gofx(fxShow):
            def gof(f):
                def goxs(xs):
                    ys = [xShow(x) for x in xs]
                    w = max(map(len, ys))

                    def arrowed(x, y):
                        return y.rjust(w, ' ') + ' -> ' + (
                            fxShow(f(x))
                        )
                    return s + '\n' + '\n'.join(
                        map(arrowed, xs, ys)
                    )
                return goxs
            return gof
        return gofx
    return gox


# MAIN ---
if __name__ == '__main__':
    main()
