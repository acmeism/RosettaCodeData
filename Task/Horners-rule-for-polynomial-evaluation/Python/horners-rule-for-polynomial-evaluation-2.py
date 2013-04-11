>>> try: from functools import reduce
except: pass

>>> def horner(coeffs, x):
	return reduce(lambda acc, c: acc * x + c, reversed(coeffs), 0)

>>> horner( (-19, 7, -4, 6), 3)
128
