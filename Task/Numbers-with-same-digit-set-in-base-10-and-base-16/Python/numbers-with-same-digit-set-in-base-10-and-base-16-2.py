'''Decimal - Hexadecimal numbers'''


# p :: Int -> Bool
def p(n):
    '''True if the hex and dec representations
       of n use the same set of digits.
    '''
    return set(hex(n)[2:]) == set(str(n))


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''Matches below 100000'''
    print(
        table(10)([
            str(x) for x in range(100000)
            if p(x)
        ])
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


# table :: Int -> [a] -> String
def table(n):
    '''A list of values formatted as
       right-justified rows of n columns.
    '''
    def go(xs):
        w = len(xs[-1])
        return '\n'.join(
            ' '.join(row) for row in chunksOf(n)([
                x.rjust(w, ' ') for x in xs
            ])
        )
    return go


# MAIN ---
if __name__ == '__main__':
    main()
