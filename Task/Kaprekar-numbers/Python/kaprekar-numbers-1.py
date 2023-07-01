>>> def k(n):
	n2 = str(n**2)
	for i in range(len(n2)):
		a, b = int(n2[:i] or 0), int(n2[i:])
		if b and a + b == n:
			return n
			#return (n, (n2[:i], n2[i:]))

		
>>> [x for x in range(1,10000) if k(x)]
[1, 9, 45, 55, 99, 297, 703, 999, 2223, 2728, 4879, 4950, 5050, 5292, 7272, 7777, 9999]
>>> len([x for x in range(1,1000000) if k(x)])
54
>>>
