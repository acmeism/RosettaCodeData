'''Matrix with two diagonals'''


# twoDiagonalMatrix :: Int -> [[Int]]
def twoDiagonalMatrix(n):
    '''A square matrix of dimension n with ones
       along both diagonals, and zeros elsewhere.
    '''
    return matrix(
        n, n, lambda row, col: int(
            row in (col, 1 + (n - col))
        )
    )


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''Matrices of dimension 7 and 8'''
    for n in [7, 8]:
        print(
            showMatrix(
                twoDiagonalMatrix(n)
            ) + '\n'
        )


# ----------------------- GENERIC ------------------------

# matrix :: Int -> Int -> ((Int, Int) -> a) -> [[a]]
def matrix(nRows, nCols, f):
    '''A matrix of a given number of columns and rows,
       in which each value is a given function over the
       tuple of its (one-based) row and column indices.
    '''
    return [
        [f(y, x) for x in range(1, 1 + nCols)]
        for y in range(1, 1 + nRows)
    ]


# showMatrix :: [[Int]] -> String
def showMatrix(rows):
    '''String representation of a matrix'''
    return '\n'.join([
        ' '.join([str(x) for x in y]) for y in rows
    ])


# MAIN ---
if __name__ == '__main__':
    main()
