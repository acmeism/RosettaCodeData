'''Fibonacci n-step number sequences'''

from itertools import chain, count, islice


# A000032 :: () -> [Int]
def A000032():
    '''Non finite sequence of Lucas numbers.
    '''
    return unfoldr(recurrence(2))([2, 1])


# nStepFibonacci :: Int -> [Int]
def nStepFibonacci(n):
    '''Non-finite series of N-step Fibonacci numbers,
       defined by a recurrence relation.
    '''
    return unfoldr(recurrence(n))(
        take(n)(
            chain(
                [1],
                (2 ** i for i in count(0))
            )
        )
    )


# recurrence :: Int -> [Int] -> Int
def recurrence(n):
    '''Recurrence relation in Fibonacci and related series.
    '''
    def go(xs):
        h, *t = xs
        return h, t + [sum(take(n)(xs))]
    return go


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''First 15 terms each n-step Fibonacci(n) series
       where n is drawn from [2..8]
    '''
    labels = "fibo tribo tetra penta hexa hepta octo nona deca"
    table = list(
        chain(
            [['lucas:'] + [
                str(x) for x in take(15)(A000032())]
             ],
            map(
                lambda k, n: list(
                    chain(
                        [k + 'nacci:'],
                        (
                            str(x) for x
                            in take(15)(nStepFibonacci(n))
                        )
                    )
                ),
                labels.split(),
                count(2)
            )
        )
    )
    print('Recurrence relation series:\n')
    print(
        spacedTable(table)
    )


# ----------------------- GENERIC ------------------------

# take :: Int -> [a] -> [a]
# take :: Int -> String -> String
def take(n):
    '''The prefix of xs of length n,
       or xs itself if n > length xs.
    '''
    def go(xs):
        return (
            xs[0:n]
            if isinstance(xs, (list, tuple))
            else list(islice(xs, n))
        )
    return go


# unfoldr :: (b -> Maybe (a, b)) -> b -> [a]
def unfoldr(f):
    '''Generic anamorphism.
       A lazy (generator) list unfolded from a seed value by
       repeated application of f until no residue remains.
       Dual to fold/reduce.
       f returns either None, or just (value, residue).
       For a strict output value, wrap in list().
    '''
    def go(x):
        valueResidue = f(x)
        while None is not valueResidue:
            yield valueResidue[0]
            valueResidue = f(valueResidue[1])
    return go


# ---------------------- FORMATTING ----------------------

# spacedTable :: [[String]] -> String
def spacedTable(rows):
    columnWidths = [
        max([len(x) for x in col])
        for col in zip(*rows)
    ]
    return '\n'.join([
        ' '.join(
            map(
                lambda x, w: x.rjust(w, ' '),
                row, columnWidths
            )
        )
        for row in rows
    ])


# MAIN ---
if __name__ == '__main__':
    main()
