>>> def lcm(p,q):
	p, q = abs(p), abs(q)
	m = p * q
	if not m: return 0
	while True:
		p %= q
		if not p: return m // q
		q %= p
		if not q: return m // p

		
>>> lcm(-6, 14)
42
>>> lcm(12, 18)
36
>>> lcm(2, 0)
0
>>>
