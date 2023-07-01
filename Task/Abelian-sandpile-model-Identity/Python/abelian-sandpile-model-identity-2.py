'''Abelian Sandpile – Identity'''

from operator import add, eq


# -------------------------- TEST --------------------------
# main :: IO ()
def main():
    '''Tests of cascades and additions'''
    s0 = [[4, 3, 3], [3, 1, 2], [0, 2, 3]]
    s1 = [[1, 2, 0], [2, 1, 1], [0, 1, 3]]
    s2 = [[2, 1, 3], [1, 0, 1], [0, 1, 0]]
    s3 = [[3, 3, 3], [3, 3, 3], [3, 3, 3]]
    s3_id = [[2, 1, 2], [1, 0, 1], [2, 1, 2]]

    series = list(cascadeSeries(s0))
    for expr in [
            'Cascade:',
            showSandPiles(
                [(' ', series[0])] + [
                    (':', xs) for xs in series[1:]
                ]
            ),
            '',
            f's1 + s2 == s2 + s1 -> {addSand(s1)(s2) == addSand(s2)(s1)}',
            showSandPiles([
                (' ', s1),
                ('+', s2),
                ('=', addSand(s1)(s2))
            ]),
            '',
            showSandPiles([
                (' ', s2),
                ('+', s1),
                ('=', addSand(s2)(s1))
            ]),
            '',
            f's3 + s3_id == s3 -> {addSand(s3)(s3_id) == s3}',
            showSandPiles([
                (' ', s3),
                ('+', s3_id),
                ('=', addSand(s3)(s3_id))
            ]),
            '',
            f's3_id + s3_id == s3_id -> {addSand(s3_id)(s3_id) == s3_id}',
            showSandPiles([
                (' ', s3_id),
                ('+', s3_id),
                ('=', addSand(s3_id)(s3_id))
            ]),

    ]:
        print(expr)


# ----------------------- SANDPILES ------------------------

# addSand :: [[Int]] -> [[Int]] -> [[Int]]
def addSand(xs):
    '''The stabilised sum of two sandpiles.
    '''
    def go(ys):
        return cascadeSeries(
            chunksOf(len(xs))(
                map(
                    add,
                    concat(xs),
                    concat(ys)
                )
            )
        )[-1]
    return go


# cascadeSeries :: [[Int]] -> [[[Int]]]
def cascadeSeries(rows):
    '''The sequence of states from a given
       sand pile to a stable condition.
    '''
    xs = list(rows)
    w = len(xs)
    return [
        list(chunksOf(w)(x)) for x
        in convergence(eq)(
            iterate(nextState(w))(
                concat(xs)
            )
        )
    ]


# convergence :: (a -> a -> Bool) -> [a] -> [a]
def convergence(p):
    '''All items of xs to the point where the binary
       p returns True over two successive values.
    '''
    def go(xs):
        def conv(prev, ys):
            y = next(ys)
            return [prev] + (
                [] if p(prev, y) else conv(y, ys)
            )
        return conv(next(xs), xs)
    return go


# nextState Int -> Int -> [Int] -> [Int]
def nextState(w):
    '''The next state of a (potentially unstable)
       flattened sand-pile matrix of row length w.
    '''
    def go(xs):
        def tumble(i):
            neighbours = indexNeighbours(w)(i)
            return [
                1 + k if j in neighbours else (
                    k - (1 + w) if j == i else k
                ) for (j, k) in enumerate(xs)
            ]
        return maybe(xs)(tumble)(
            findIndex(lambda x: w < x)(xs)
        )
    return go


# indexNeighbours :: Int -> Int -> [Int]
def indexNeighbours(w):
    '''Indices vertically and horizontally adjoining the
       given index in a flattened matrix of dimension w.
    '''
    def go(i):
        lastCol = w - 1
        iSqr = (w * w)
        col = i % w
        return [
            j for j in [i - w, i + w]
            if -1 < j < iSqr
        ] + ([i - 1] if 0 != col else []) + (
            [1 + i] if lastCol != col else []
        )
    return go


# ------------------------ DISPLAY -------------------------

# showSandPiles :: [(String, [[Int]])] -> String
def showSandPiles(pairs):
    '''Indented multi-line representation
       of a sequence of matrices, delimited
       by preceding operators or indents.
    '''
    return '\n'.join([
        ' '.join([' '.join(map(str, seq)) for seq in tpl])
        for tpl in zip(*[
            zip(
                *[list(str(pfx).center(len(rows)))]
                + list(zip(*rows))
            )
            for (pfx, rows) in pairs
        ])
    ])


# ------------------------ GENERIC -------------------------

# chunksOf :: Int -> [a] -> [[a]]
def chunksOf(n):
    '''A series of lists of length n, subdividing the
       contents of xs. Where the length of xs is not evenly
       divible, the final list will be shorter than n.
    '''
    def go(xs):
        ys = list(xs)
        return (
            ys[i:n + i] for i in range(0, len(ys), n)
        ) if 0 < n else None
    return go


# concat :: [[a]] -> [a]
def concat(xs):
    '''The concatenation of all
       elements in a list.
    '''
    return [x for lst in xs for x in lst]


# findIndex :: (a -> Bool) -> [a] -> Maybe Int
def findIndex(p):
    '''Just the first index at which an
       element in xs matches p,
       or Nothing if no elements match.
    '''
    def go(xs):
        return next(
            (i for (i, x) in enumerate(xs) if p(x)),
            None
        )
    return go


# iterate :: (a -> a) -> a -> Gen [a]
def iterate(f):
    '''An infinite list of repeated
       applications of f to x.
    '''
    def go(x):
        v = x
        while True:
            yield v
            v = f(v)
    return go


# maybe :: b -> (a -> b) -> Maybe a -> b
def maybe(v):
    '''Either the default value v, if x is None,
       or the application of f to x.
    '''
    def go(f):
        def g(x):
            return v if None is x else f(x)
        return g
    return go


# MAIN ---
if __name__ == '__main__':
    main()
