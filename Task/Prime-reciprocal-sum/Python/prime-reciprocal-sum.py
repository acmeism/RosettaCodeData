''' rosettacode.org/wiki/Prime_reciprocal_sum '''
from fractions import Fraction
from sympy import nextprime


def abbreviated(bigstr, label="digits", maxlen=40, j=20):
    ''' Abbreviate string by showing beginning / end and number of chars '''
    wid = len(bigstr)
    return bigstr if wid <= maxlen else bigstr[:j] + '..' + bigstr[-j:] + f' ({wid} {label})'


def ceil(rat):
    ''' ceil function for Fractions '''
    return rat.numerator if rat.denominator == 1 else rat.numerator // rat.denominator + 1


psum = Fraction(0, 1)
for i in range(1, 15):  # get first 14 in sequence
    next_in_seq = nextprime(ceil(Fraction(1, 1 - psum)))
    psum += Fraction(1, next_in_seq)
    print(f'{i:2}:', abbreviated(str(next_in_seq)))
