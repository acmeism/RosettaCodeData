'''Sums and products of divisors'''

from math import floor, sqrt
from functools import reduce
from operator import add, mul


# divisors :: Int -> [Int]
def divisors(n):
    '''List of all divisors of n including n itself.
    '''
    root = floor(sqrt(n))
    lows = [x for x in range(1, 1 + root) if 0 == n % x]
    return lows + [n // x for x in reversed(lows)][
        (1 if n == (root * root) else 0):
    ]


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''Sums and products of divisors for each integer in range [1..50]
    '''
    print('Products of divisors:')
    for n in range(1, 1 + 50):
        print(n, '->', reduce(mul, divisors(n), 1))

    print('Sums of divisors:')
    for n in range(1, 1 + 100):
        print(n, '->', reduce(add, divisors(n), 0))


# MAIN ---
if __name__ == '__main__':
    main()
