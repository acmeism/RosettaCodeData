from fractions import Fraction
from math import log10

def maxnum(x):
    return ''.join(str(n) for n in sorted(x, reverse=True,
                          key=lambda i: Fraction(i, 10**(int(log10(i))+1)-1)))

for numbers in [(1, 34, 3, 98, 9, 76, 45, 4), (54, 546, 548, 60)]:
    print('Numbers: %r\n  Largest integer: %15s' % (numbers, maxnum(numbers)))
