'''Sum of first N cubes'''

from math import factorial


# sumOfFirstNCubes :: Int -> Int
def sumOfFirstNCubes(n):
    '''The sum of the first n cubes.'''
    return binomialCoefficient(1 + n)(2) ** 2


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''First fifty values (N drawn from [0 .. 49])
    '''
    print(
        table(10)([
            str(sumOfFirstNCubes(n)) for n
            in range(0, 1 + 49)
        ])
    )


# ----------------------- GENERIC ------------------------

# binomialCoefficient :: Int -> Int -> Int
def binomialCoefficient(n):
    '''The coefficient of the term x^k in the polynomial
       expansion of the binomial power (1 + x)^n
    '''
    def go(k):
        return 0 if n < k else factorial(n) // (
            factorial(k) * factorial(n - k)
        )
    return go


# ----------------------- DISPLAY ------------------------

# chunksOf :: Int -> [a] -> [[a]]
def chunksOf(n):
    '''A series of lists of length n, subdividing the
       contents of xs. Where the length of xs is not evenly
       divisible, the final list will be shorter than n.
    '''
    def go(xs):
        return (
            xs[i:n + i] for i in range(0, len(xs), n)
        ) if 0 < n else None
    return go


# table :: Int -> [String] -> String
def table(n):
    '''A list of strings formatted as
       right-justified rows of n columns.
    '''
    def go(xs):
        w = len(xs[-1])
        return '\n'.join(
            ' '.join(row) for row in chunksOf(n)([
                s.rjust(w, ' ') for s in xs
            ])
        )
    return go


# MAIN ---
if __name__ == '__main__':
    main()
