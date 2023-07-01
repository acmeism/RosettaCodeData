'''Luhn test of credit card numbers'''

from operator import add, mul
from functools import reduce
from itertools import cycle


# luhn :: Integer -> Bool
def luhn(n):
    '''True if n is a valid Luhn credit card number.'''
    def divMod10Sum(a, x):
        return a + add(*divmod(x, 10))
    return 0 == reduce(
        divMod10Sum,
        map(
            mul,
            cycle([1, 2]),
            map(int, reversed(str(n)))
        ),
        0
    ) % 10


# ---------------------------TEST---------------------------
# main :: IO ()
def main():
    '''Tests'''
    print(list(
        map(luhn, [
            49927398716, 49927398717,
            1234567812345678, 1234567812345670
        ])
    ))


if __name__ == '__main__':
    main()
