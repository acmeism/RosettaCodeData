'''Numbers matching a function of their digits'''

from functools import reduce
from operator import mul


# p :: Int -> Bool
def p(n):
    '''True if n is divisible by each of its digits,
       but not divisible by the product of those digits.
    '''
    digits = [int(c) for c in str(n)]
    return not 0 in digits and (
        0 != (n % reduce(mul, digits, 1))
    ) and all(0 == n % d for d in digits)


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''Numbers below 1000 which satisfy p
    '''
    xs = [
        str(n) for n in range(1, 1000)
        if p(n)
    ]
    w = len(xs[-1])
    print(f'{len(xs)} matching numbers:\n')
    print('\n'.join(
        ' '.join(cell.rjust(w, ' ') for cell in row)
        for row in chunksOf(10)(xs)
    ))


# ----------------------- GENERIC ------------------------

# chunksOf :: Int -> [a] -> [[a]]
def chunksOf(n):
    '''A series of lists of length n, subdividing the
       contents of xs. Where the length of xs is not evenly
       divible, the final list will be shorter than n.
    '''
    def go(xs):
        return (
            xs[i:n + i] for i in range(0, len(xs), n)
        ) if 0 < n else None
    return go


# MAIN ---
if __name__ == '__main__':
    main()
