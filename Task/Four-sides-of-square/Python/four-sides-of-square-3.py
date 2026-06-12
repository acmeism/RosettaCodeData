'''Four sides of a square'''


# fourSides :: Int -> [[Int]]
def fourSides(n):
    '''A square grid with ones in all edge values
       and zeros elsewhere.
    '''
    edge = [1, n]
    return matrix(
        n, n, lambda row, col: int(
            row in edge or col in edge
        )
    )


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''Square grids of dimension 7 and 10'''
    for n in [7, 10]:
        print(
            showMatrix(
                fourSides(n)
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
