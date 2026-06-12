'''Mosaic grid'''


# mosaic :: Int -> [[Int]]
def mosaic(n):
    '''Grid of alternating ones and zeroes,
       starting with one at top left.
    '''
    return matrix(
        n, n,
        lambda y, x: (1 + y + x) % 2
    )


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''Test'''
    for n in [7, 8]:
        print(
            showMatrix(
                mosaic(n)
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


# showMatrix :: [[a]] -> String
def showMatrix(rows):
    '''String representation of a matrix'''
    return '\n'.join([
        ' '.join([str(x) for x in y]) for y in rows
    ])


# MAIN ---
if __name__ == '__main__':
    main()
