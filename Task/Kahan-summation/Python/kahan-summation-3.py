>>> from decimal import localcontext, Decimal
>>>
>>> with localcontext() as ctx:
	one, ten = Decimal('1.0'), Decimal('10')
	eps = one
	while one + eps != one:
		eps = eps / ten
	print('eps is:', eps)
	print('Simple sum is:', (one + eps) - eps)
	print('Kahan sum is:', kahansum([one, eps, -eps]))

	
eps is: 1E-28
Simple sum is: 0.9999999999999999999999999999
Kahan sum is: 1.000000000000000000000000000
>>>
