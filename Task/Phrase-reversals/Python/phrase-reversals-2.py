'''String reversals at different levels.'''


# reversedCharacters :: String -> String
def reversedCharacters(s):
    '''All characters in reversed sequence.'''
    return reverse(s)


# wordsWithReversedCharacters :: String -> String
def wordsWithReversedCharacters(s):
    '''Characters within each word in reversed sequence.'''
    return unwords(map(reverse, words(s)))


# reversedWordOrder :: String -> String
def reversedWordOrder(s):
    '''Sequence of words reversed.'''
    return unwords(reverse(words(s)))


# TESTS -------------------------------------------------
# main :: IO()
def main():
    '''Tests'''

    s = 'rosetta code phrase reversal'
    print(
        tabulated(s + ':\n')(
            lambda f: f.__name__
        )(lambda s: "'" + s + "'")(
            lambda f: f(s)
        )([
            reversedCharacters,
            wordsWithReversedCharacters,
            reversedWordOrder
        ])
    )


# GENERIC -------------------------------------------------


# compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
def compose(g):
    '''Function composition.'''
    return lambda f: lambda x: g(f(x))


# reverse :: [a] -> [a]
# reverse :: String -> String
def reverse(xs):
    '''The elements of xs in reverse order.'''
    return xs[::-1] if isinstance(xs, str) else (
        list(reversed(xs))
    )


# tabulated :: String -> (a -> String) ->
#                        (b -> String) ->
#                        (a -> b) -> [a] -> String
def tabulated(s):
    '''Heading -> x display function -> fx display function ->
                f -> value list -> tabular string.'''
    def go(xShow, fxShow, f, xs):
        w = max(map(compose(len)(xShow), xs))
        return s + '\n' + '\n'.join(
            xShow(x).rjust(w, ' ') + ' -> ' + fxShow(f(x)) for x in xs
        )
    return lambda xShow: lambda fxShow: lambda f: lambda xs: go(
        xShow, fxShow, f, xs
    )


# unwords :: [String] -> String
def unwords(xs):
    '''A space-separated string derived from a list of words.'''
    return ' '.join(xs)


# words :: String -> [String]
def words(s):
    '''A list of words delimited by characters
       representing white space.'''
    return s.split()


if __name__ == '__main__':
    main()
