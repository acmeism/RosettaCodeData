>>> from itertools import groupby
>>> def lookandsay(number):
	return ''.join( str(len(list(g))) + k
		        for k,g in groupby(number) )

>>> numberstring='1'
>>> for i in range(10):
	print numberstring
	numberstring = lookandsay(numberstring)
