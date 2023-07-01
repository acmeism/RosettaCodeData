>>> def maprange( a, b, s):
	(a1, a2), (b1, b2) = a, b
	return  b1 + ((s - a1) * (b2 - b1) / (a2 - a1))

>>> for s in range(11):
	print("%2g maps to %g" % (s, maprange( (0, 10), (-1, 0), s)))

	
 0 maps to -1
 1 maps to -0.9
 2 maps to -0.8
 3 maps to -0.7
 4 maps to -0.6
 5 maps to -0.5
 6 maps to -0.4
 7 maps to -0.3
 8 maps to -0.2
 9 maps to -0.1
10 maps to 0
