'''Integers needing any alpha digits in hex'''


# p :: Int -> Bool
def p(n):
    '''True if n requires any digits above 9
       when expressed as a hexadecimal.
    '''
    return 9 < n and (9 < n % 16 or p(n // 16))


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''Matches for the predicate p in the range [0..500]'''
    xs = [
        str(n) for n in range(1, 1 + 500)
        if p(n)
    ]
    print(f'{len(xs)} matches for the predicate:\n')
    print(
        table(6)(xs)
    )


# ----------------------- GENERIC ------------------------

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
