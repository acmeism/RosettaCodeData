'''Magic squares of doubly even order'''

from itertools import chain, repeat
from functools import reduce
from math import log


# doublyEvenMagicSquare :: Int -> [[Int]]
def doublyEvenMagicSquare(n):
    '''Magic square of order n'''

    # magic :: Int -> [Bool]
    def magic(n):
        '''Truth-table series'''
        if 0 < n:
            xs = magic(n - 1)
            return xs + [not x for x in xs]
        else:
            return [True]

    sqr = n * n
    power = log(sqr, 2)
    scale = replicate(n / 4)
    return chunksOf(n)([
        succ(i) if bln else sqr - i for i, bln in
        enumerate(magic(power) if isInteger(power) else (
            flatten(scale(
                map(scale, chunksOf(4)(magic(4)))
            ))
        ))
    ])


# TEST ----------------------------------------------------
# main :: IO()
def main():
    '''Tests'''

    order = 8
    magicSquare = doublyEvenMagicSquare(order)

    print(
        'Row sums: ',
        [sum(xs) for xs in magicSquare],
        '\nCol sums:',
        [sum(xs) for xs in transpose(magicSquare)],
        '\n1st diagonal sum:',
        sum(magicSquare[i][i] for i in range(0, order)),
        '\n2nd diagonal sum:',
        sum(magicSquare[i][(order - 1) - i] for i in range(0, order)),
        '\n'
    )
    print(wikiTable({
        'class': 'wikitable',
        'style': cssFromDict({
            'text-align': 'center',
            'color': '#605B4B',
            'border': '2px solid silver'
        }),
        'colwidth': '3em'
    })(magicSquare))


# GENERIC -------------------------------------------------


# chunksOf :: Int -> [a] -> [[a]]
def chunksOf(n):
    '''A series of lists of length n,
       subdividing the contents of xs.
       Where the length of xs is not evenly divible
       the final list will be shorter than n.'''
    return lambda xs: reduce(
        lambda a, i: a + [xs[i:n + i]],
        range(0, len(xs), n), []
    ) if 0 < n else []


# concatMap :: (a -> [b]) -> [a] -> [b]
def concatMap(f):
    '''Concatenated list over which a function has been mapped.
       The list monad can be derived by using a function f which
       wraps its output a in list
       (using an empty list to represent computational failure).'''
    return lambda xs: list(
        chain.from_iterable(
            map(f, xs)
        )
    )


# cssFromDict :: Dict -> String
def cssFromDict(dct):
    '''CSS string serialized from key values in a Dictionary.'''
    return reduce(
        lambda a, k: a + k + ':' + dct[k] + '; ', dct.keys(), ''
    )


# flatten :: NestedList a -> [a]
def flatten(x):
    '''A list of atoms resulting from fully flattening
       an arbitrarily nested list.'''
    return concatMap(flatten)(x) if isinstance(x, list) else [x]


# isInteger :: Num -> Bool
def isInteger(n):
    '''Divisible by one without remainder ?'''
    return 0 == (n - int(n))


# replicate :: Int -> a -> [a]
def replicate(n):
    '''A list of length n in which every element
       has the value x.'''
    return lambda x: list(repeat(x, n))


# succ :: Enum a => a -> a
def succ(x):
    '''The successor of a value. For numeric types, (1 +).'''
    return 1 + x if isinstance(x, int) else (
        chr(1 + ord(x))
    )


# transpose :: Matrix a -> Matrix a
def transpose(m):
    '''The rows and columns of the argument transposed.
       (The matrix containers and rows can be lists or tuples).'''
    if m:
        inner = type(m[0])
        z = zip(*m)
        return (type(m))(
            map(inner, z) if tuple != inner else z
        )
    else:
        return m


# wikiTable :: Dict -> [[a]] -> String
def wikiTable(opts):
    '''List of lists rendered as a wiki table string.'''
    def colWidth():
        return 'width:' + opts['colwidth'] + '; ' if (
            'colwidth' in opts
        ) else ''

    def cellStyle():
        return opts['cell'] if 'cell' in opts else ''

    return lambda rows: '{| ' + reduce(
        lambda a, k: (
            a + k + '="' + opts[k] + '" ' if k in opts else a
        ),
        ['class', 'style'],
        ''
    ) + '\n' + '\n|-\n'.join(
        '\n'.join(
            ('|' if (0 != i and ('cell' not in opts)) else (
                '|style="' + colWidth() + cellStyle() + '"|'
            )) + (
                str(x) or ' '
            ) for x in row
        ) for i, row in enumerate(rows)
    ) + '\n|}\n\n'


if __name__ == '__main__':
    main()
