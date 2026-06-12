'''Distance to edge of matrix'''

from itertools import chain, product


# distancesToEdge :: Int -> [[Int]]
def distancesToEdge(n):
    '''A square matrix of dimension n, in which each
       value is the minimum distance from the matrix
       position to the edge of the matrix.
    '''
    lastIndex = n - 1
    axis = range(0, n)
    return chunksOf(n)([
        min(x, y, lastIndex - x, lastIndex - y)
        for (x, y) in product(axis, axis)
    ])


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''Square matrices of distances to the matrix edge.
       Sample matrices of dimensions [10, 9, 2, 1].
    '''
    print('\n\n'.join([
        showMatrix(distancesToEdge(n)) for n
        in [10, 9, 2, 1]
    ]))


# ----------------------- DISPLAY ------------------------

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


# ----------------------- GENERIC ------------------------

# chunksOf :: Int -> [a] -> [[a]]
def chunksOf(n):
    '''A series of lists of length n, subdividing the
       contents of xs. Where the length of xs is not evenly
       divisible, the final list will be shorter than n.
    '''
    def go(xs):
        return [
            xs[i:n + i] for i in range(0, len(xs), n)
        ] if 0 < n else None
    return go


# MAIN ---
if __name__ == '__main__':
    main()
