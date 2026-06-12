'''Minimum distances to edge of matrix'''

from itertools import chain


# distanceFromEdge :: Int -> [[Int]]
def distanceFromEdge(n):
    '''A matrix of minimum distances to the
       edge of the matrix.
    '''
    return matrix(n)(n)(
        lambda row, col: min([
            row - 1, col - 1,
            n - row, n - col
        ])
    )


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''Test'''
    for n in [10, 9, 2, 1]:
        print(
            showMatrix(
                distanceFromEdge(n)
            ) + "\n"
        )


# ----------------------- GENERIC ------------------------

# matrix :: Int -> Int -> ((Int, Int) -> a) -> [[a]]
def matrix(nRows):
    '''A matrix of a given number of columns and rows,
       in which each value is a given function over the
       tuple of its (one-based) row and column indices.
    '''
    def go(nCols):
        def g(f):
            return [
                [f(y, x) for x in range(1, 1 + nCols)]
                for y in range(1, 1 + nRows)
            ]
        return g
    return go


# showMatrix :: [[Int]] -> String
def showMatrix(xs):
    '''String representation of xs
       as a matrix.
    '''
    def go():
        rows = [[str(x) for x in row] for row in xs]
        w = max(map(len, chain.from_iterable(rows)))
        return "\n".join(
            " ".join(k.rjust(w, ' ') for k in row)
            for row in rows
        )
    return go() if xs else ''


# MAIN ---
if __name__ == '__main__':
    main()
