'''Determine if a string has all the same characters'''

from itertools import takewhile


# inconsistentChar :: String -> Maybe (Int, Char)
def inconsistentChar(s):
    '''Just the first inconsistent character and its position,
       or Nothing if all the characters of s are the same,
    '''
    if s:
        h = s[0]
        pre, post = span(lambda c: h == c)(s)
        return Just((len(pre), post[0])) if post else Nothing()
    else:
        return Nothing()


# --------------------------TEST---------------------------
# main :: IO ()
def main():
    '''Consistency tests of seven strings'''

    samples = ['', '   ', '2', '333', '.55', 'tttTTT', '4444 444']
    w = 1 + max(map(len, samples))

    def pfx(s):
        return ("'" + s).rjust(w) + "' -> "

    def charPosn(ic):
        i, c = ic
        return "inconsistent '" + c + "' (" + hex(ord(c)) + ")" + (
            " at char " + str(1 + i)
        )

    print(main.__doc__ + ':\n')
    print(
        '\n'.join([
            pfx(s) + maybe('consistent')(charPosn)(
                inconsistentChar(s)
            )
            for s in samples
        ])
    )


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


# maybe :: b -> (a -> b) -> Maybe a -> b
def maybe(v):
    '''Either the default value v, if m is Nothing,
       or the application of f to x,
       where m is Just(x).
    '''
    return lambda f: lambda m: v if None is m or m.get('Nothing') else (
        f(m.get('Just'))
    )


# span :: (a -> Bool) -> [a] -> ([a], [a])
def span(p):
    '''The longest (possibly empty) prefix of xs
       that contains only elements satisfying p,
       tupled with the remainder of xs.
       span p xs is equivalent to (takeWhile p xs, dropWhile p xs).
    '''
    def go(xs):
        prefix = list(takewhile(p, xs))
        return (prefix, xs[len(prefix):])
    return lambda xs: go(xs)


# MAIN ---
if __name__ == '__main__':
    main()
