>>> from fractions import Fraction
>>> for s in range(11):
	print("%2g maps to %s" % (s, maprange( (0, 10), (-1, 0), Fraction(s))))

	
 0 maps to -1
 1 maps to -9/10
 2 maps to -4/5
 3 maps to -7/10
 4 maps to -3/5
 5 maps to -1/2
 6 maps to -2/5
 7 maps to -3/10
 8 maps to -1/5
 9 maps to -1/10
10 maps to 0
>>>
