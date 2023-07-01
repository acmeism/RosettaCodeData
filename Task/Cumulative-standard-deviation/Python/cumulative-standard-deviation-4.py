>>> from math import sqrt
>>> def sdcreator():
	sum = sum2 = n = 0
	while True:
		x = yield sqrt(sum2/n - sum*sum/n/n) if n else None

		sum  += x
		sum2 += x*x
		n    += 1.0

>>> sd = sdcreator()
>>> sd.send(None)
>>> for value in (2,4,4,4,5,5,7,9):
	print (value, sd.send(value))

	
2 0.0
4 1.0
4 0.942809041582
4 0.866025403784
5 0.979795897113
5 1.0
7 1.39970842445
9 2.0
