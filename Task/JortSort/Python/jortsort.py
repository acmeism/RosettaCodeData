>>> def jortsort(sequence):
	return list(sequence) == sorted(sequence)
>>> for data in [(1,2,4,3), (14,6,8), ['a', 'c'], ['s', 'u', 'x'], 'CVGH', 'PQRST']:
	print(f'jortsort({repr(data)}) is {jortsort(data)}')
jortsort((1, 2, 4, 3)) is False
jortsort((14, 6, 8)) is False
jortsort(['a', 'c']) is True
jortsort(['s', 'u', 'x']) is True
jortsort('CVGH') is False
jortsort('PQRST') is True
>>>
