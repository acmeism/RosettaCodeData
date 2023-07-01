'''Set consolidation'''

from functools import (reduce)


# consolidated :: Ord a => [Set a] -> [Set a]
def consolidated(sets):
    '''A consolidated list of sets.'''
    def go(xs, s):
        if xs:
            h = xs[0]
            return go(xs[1:], h.union(s)) if (
                h.intersection(s)
            ) else [h] + go(xs[1:], s)
        else:
            return [s]
    return reduce(go, sets, [])


# TESTS ---------------------------------------------------
# main :: IO ()
def main():
    '''Illustrative consolidations.'''

    print(
        tabulated('Consolidation of sets of characters:')(
            lambda x: str(list(map(compose(concat)(list), x)))
        )(str)(
            consolidated
        )(list(map(lambda xs: list(map(set, xs)), [
            ['ab', 'cd'],
            ['ab', 'bd'],
            ['ab', 'cd', 'db'],
            ['hik', 'ab', 'cd', 'db', 'fgh']
        ])))
    )


# DISPLAY OF RESULTS --------------------------------------

# compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
def compose(g):
    '''Right to left function composition.'''
    return lambda f: lambda x: g(f(x))


# concat :: [String] -> String
def concat(xs):
    '''Concatenation of strings in xs.'''
    return ''.join(xs)


# tabulated :: String -> (a -> String) ->
#                        (b -> String) ->
#                        (a -> b) -> [a] -> String
def tabulated(s):
    '''Heading -> x display function -> fx display function ->
          f -> value list -> tabular string.'''
    def go(xShow, fxShow, f, xs):
        w = max(map(compose(len)(xShow), xs))
        return s + '\n' + '\n'.join([
            xShow(x).rjust(w, ' ') + ' -> ' + fxShow(f(x)) for x in xs
        ])
    return lambda xShow: lambda fxShow: (
        lambda f: lambda xs: go(
            xShow, fxShow, f, xs
        )
    )


# MAIN ---
if __name__ == '__main__':
    main()
