>>> from fractions import Fraction
>>> for d in (0.9054054, 0.518518, 0.75): print(d, Fraction.from_float(d).limit_denominator(100))

0.9054054 67/74
0.518518 14/27
0.75 3/4
>>> for d in '0.9054054 0.518518 0.75'.split(): print(d, Fraction(d))

0.9054054 4527027/5000000
0.518518 259259/500000
0.75 3/4
>>>
