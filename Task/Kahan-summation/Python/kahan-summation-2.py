>>> eps = 1.0
>>> while 1.0 + eps != 1.0:
	eps = eps / 2.0

	
>>> eps
1.1102230246251565e-16
>>> (1.0 + eps) - eps
0.9999999999999999
>>> kahansum([1, eps, -eps])
1.0
>>>
>>>
>>> # Info on this implementation of floats
>>> import sys
>>> sys.float_info
sys.float_info(max=1.7976931348623157e+308, max_exp=1024, max_10_exp=308, min=2.2250738585072014e-308, min_exp=-1021, min_10_exp=-307, dig=15, mant_dig=53, epsilon=2.220446049250313e-16, radix=2, rounds=1)
>>>
