>>> def area_by_shoelace2(x, y):
	return abs(sum(x[i-1]*y[i]-x[i]*y[i-1] for i in range(len(x)))) / 2.

>>> points = [(3,4), (5,11), (12,8), (9,5), (5,6)]
>>> x, y = zip(*points)
>>> area_by_shoelace2(x, y)
30.0
>>>
