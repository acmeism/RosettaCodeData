>>> from fractions import Fraction
>>> Fraction.__repr__ = lambda x: '%i/%i' % (x.numerator, x.denominator)
>>> [vdc(i, base=Fraction(2)) for i in range(10)]
[0, 1/2, 1/4, 3/4, 1/8, 5/8, 3/8, 7/8, 1/16, 9/16]
