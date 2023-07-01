'''Towers of Hanoi'''

from itertools import accumulate, chain, repeat
from inspect import signature
import operator


# hanoi :: Int -> [(Int, Int)]
def hanoi(n):
    '''A list of index pairs, representing disk moves
       between indexed Hanoi positions.
    '''
    def go(n, a, b, c):
        p = n - 1
        return (
            go(p, a, c, b) + [(a, b)] + go(p, c, b, a)
        ) if 0 < n else []
    return go(n, 0, 2, 1)


# hanoiState :: ([Int],[Int],[Int], String) -> (Int, Int) ->
#               ([Int],[Int],[Int], String)
def hanoiState(tpl, ab):
    '''A new Hanoi tower state'''
    a, b = ab
    xs, ys = tpl[a], tpl[b]

    w = 3 * (2 + (2 * max(map(max, filter(len, tpl[:-1])))))

    def delta(i):
        return tpl[i] if i not in ab else xs[1:] if (
            i == a
        ) else [xs[0]] + ys

    tkns = moveName(('left', 'mid', 'right'))(ab)
    caption = ' '.join(tkns)
    return tuple(map(delta, [0, 1, 2])) + (
        (caption if tkns[0] != 'mid' else caption.rjust(w, ' ')),
    )


# showHanoi :: ([Int],[Int],[Int], String) -> String
def showHanoi(tpl):
    '''Captioned string representation of an updated Hanoi tower state.'''

    def fullHeight(n):
        return lambda xs: list(repeat('', n - len(xs))) + xs

    mul = curry(operator.mul)
    lt = curry(operator.lt)
    rods = fmap(fmap(mul('__')))(
        list(tpl[0:3])
    )
    h = max(map(len, rods))
    w = 2 + max(
        map(
            compose(max)(fmap(len)),
            filter(compose(lt(0))(len), rods)
        )
    )
    xs = fmap(concat)(
        transpose(fmap(
            compose(fmap(center(w)(' ')))(
                fullHeight(h)
            )
        )(rods))
    )
    return tpl[3] + '\n\n' + unlines(xs) + '\n' + ('___' * w)


# moveName :: (String, String, String) -> (Int, Int) -> [String]
def moveName(labels):
    '''(from, to) index pair represented as an a -> b string.'''
    def go(ab):
        a, b = ab
        return [labels[a], ' to ', labels[b]] if a < b else [
            labels[b], ' from ', labels[a]
        ]
    return lambda ab: go(ab)


# TEST ----------------------------------------------------
def main():
    '''Visualisation of a Hanoi tower sequence for N discs.
    '''
    n = 3
    print('Hanoi sequence for ' + str(n) + ' disks:\n')
    print(unlines(
        fmap(showHanoi)(
            scanl(hanoiState)(
                (enumFromTo(1)(n), [], [], '')
            )(hanoi(n))
        )
    ))


# GENERIC -------------------------------------------------

# center :: Int -> Char -> String -> String
def center(n):
    '''String s padded with c to approximate centre,
       fitting in but not truncated to width n.'''
    return lambda c: lambda s: s.center(n, c)


# compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
def compose(g):
    '''Right to left function composition.'''
    return lambda f: lambda x: g(f(x))


# concat :: [[a]] -> [a]
# concat :: [String] -> String
def concat(xs):
    '''The concatenation of all the elements
       in a list or iterable.'''

    def f(ys):
        zs = list(chain(*ys))
        return ''.join(zs) if isinstance(ys[0], str) else zs

    return (
        f(xs) if isinstance(xs, list) else (
            chain.from_iterable(xs)
        )
    ) if xs else []


# curry :: ((a, b) -> c) -> a -> b -> c
def curry(f):
    '''A curried function derived
       from an uncurried function.'''
    if 1 < len(signature(f).parameters):
        return lambda x: lambda y: f(x, y)
    else:
        return f


# enumFromTo :: (Int, Int) -> [Int]
def enumFromTo(m):
    '''Integer enumeration from m to n.'''
    return lambda n: list(range(m, 1 + n))


# fmap :: (a -> b) -> [a] -> [b]
def fmap(f):
    '''fmap over a list.
       f lifted to a function over a list.
    '''
    return lambda xs: list(map(f, xs))


# scanl :: (b -> a -> b) -> b -> [a] -> [b]
def scanl(f):
    '''scanl is like reduce, but returns a succession of
       intermediate values, building from the left.
    '''
    return lambda a: lambda xs: (
        accumulate(chain([a], xs), f)
    )


# showLog :: a -> IO String
def showLog(*s):
    '''Arguments printed with
       intercalated arrows.'''
    print(
        ' -> '.join(map(str, s))
    )


# transpose :: Matrix a -> Matrix a
def transpose(m):
    '''The rows and columns of the argument transposed.
       (The matrix containers and rows can be lists or tuples).
    '''
    if m:
        inner = type(m[0])
        z = zip(*m)
        return (type(m))(
            map(inner, z) if tuple != inner else z
        )
    else:
        return m


# unlines :: [String] -> String
def unlines(xs):
    '''A single string derived by the intercalation
       of a list of strings with the newline character.
    '''
    return '\n'.join(xs)


# TEST ----------------------------------------------------
if __name__ == '__main__':
    main()
