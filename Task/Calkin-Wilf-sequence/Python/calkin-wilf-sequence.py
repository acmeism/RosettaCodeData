from fractions import Fraction
from math import floor
from itertools import islice, groupby


def cw():
    a = Fraction(1)
    while True:
        yield a
        a = 1 / (2 * floor(a) + 1 - a)

def r2cf(rational):
    num, den = rational.numerator, rational.denominator
    while den:
        num, (digit, den) = den, divmod(num, den)
        yield digit

def get_term_num(rational):
    ans, dig, pwr = 0, 1, 0
    for n in r2cf(rational):
        for _ in range(n):
            ans |= dig << pwr
            pwr += 1
        dig ^= 1
    return ans


if __name__ == '__main__':
    print('TERMS 1..20: ', ', '.join(str(x) for x in islice(cw(), 20)))
    x = Fraction(83116, 51639)
    print(f"\n{x} is the {get_term_num(x):_}'th term.")
