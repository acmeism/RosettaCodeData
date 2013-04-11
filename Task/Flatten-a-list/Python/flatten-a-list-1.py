>>> def flatten(lst):
	return sum( ([x] if not isinstance(x, list) else flatten(x)
		     for x in lst), [] )

>>> lst = [[1], 2, [[3,4], 5], [[[]]], [[[6]]], 7, 8, []]
>>> flatten(lst)
[1, 2, 3, 4, 5, 6, 7, 8]
