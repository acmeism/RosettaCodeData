>>> from itertools import product
>>> nuggets = set(range(101))
>>> for s, n, t in product(range(100//6+1), range(100//9+1), range(100//20+1)):
	nuggets.discard(6*s + 9*n + 20*t)

	
>>> max(nuggets)
43
>>>
