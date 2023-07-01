>>> from itertools import groupby, islice
>>>
>>> def lookandsay(number='1'):
	while True:
		yield number
		number = ''.join( str(len(list(g))) + k
		                  for k,g in groupby(number) )

		
>>> print('\n'.join(islice(lookandsay(), 10)))
1
11
21
1211
111221
312211
13112221
1113213211
31131211131221
13211311123113112211
