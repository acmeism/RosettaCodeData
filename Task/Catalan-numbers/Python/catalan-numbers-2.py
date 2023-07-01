'''Catalan numbers'''

from itertools import accumulate, chain, count, islice


# catalans3 :: [Int]
def catalans3():
    '''Infinite sequence of Catalan numbers
    '''
    def go(c, n):
        return 2 * c * pred(2 * n) // succ(n)

    return accumulate(
        chain([1], count(1)), go
    )


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''Catalan numbers, definition 3'''
    print("Catalans 1-15:\n")
    print(
        '\n'.join([
            f'{n:>10}' for n
            in islice(catalans3(), 15)
        ])
    )


# ----------------------- GENERIC ------------------------

# pred :: Int -> Int
def pred(n):
    '''Predecessor function'''
    return n - 1


# succ :: Int -> Int
def succ(n):
    '''Successor function'''
    return 1 + n


# MAIN ---
if __name__ == '__main__':
    main()
