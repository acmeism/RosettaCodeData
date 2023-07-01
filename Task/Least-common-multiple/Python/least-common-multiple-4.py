>>> def lcm(*values):
	values = set([abs(int(v)) for v in values])
	if values and 0 not in values:
		n = n0 = max(values)
		values.remove(n)
		while any( n % m for m in values ):
			n += n0
		return n
	return 0

>>> lcm(-6, 14)
42
>>> lcm(2, 0)
0
>>> lcm(12, 18)
36
>>> lcm(12, 18, 22)
396
>>>
