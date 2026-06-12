'''Binary and Ternary digit sums both prime'''


# digitSumsPrime :: Int -> [Int] -> Bool
def digitSumsPrime(n):
    '''True if the digits of n in each
       given base have prime sums.
    '''
    def go(bases):
        return all(
            isPrime(digitSum(b)(n))
            for b in bases
        )
    return go


# digitSum :: Int -> Int -> Int
def digitSum(base):
    '''The sum of the digits of n in a given base.
    '''
    def go(n):
        q, r = divmod(n, base)
        return go(q) + r if n else 0
    return go


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''Matching integers in the range [1..199]'''
    xs = [
        str(n) for n in range(1, 200)
        if digitSumsPrime(n)([2, 3])
    ]
    print(f'{len(xs)} matches in [1..199]\n')
    print(table(10)(xs))


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


# isPrime :: Int -> Bool
def isPrime(n):
    '''True if n is prime.'''
    if n in (2, 3):
        return True
    if 2 > n or 0 == n % 2:
        return False
    if 9 > n:
        return True
    if 0 == n % 3:
        return False

    def p(x):
        return 0 == n % x or 0 == n % (2 + x)

    return not any(map(p, range(5, 1 + int(n ** 0.5), 6)))


# table :: Int -> [String] -> String
def table(n):
    '''A list of strings formatted as
       rows of n (right justified) columns.
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
