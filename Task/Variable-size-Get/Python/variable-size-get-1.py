>>> from array import array
>>> argslist = [('l', []), ('c', 'hello world'), ('u', u'hello \u2641'),
	('l', [1, 2, 3, 4, 5]), ('d', [1.0, 2.0, 3.14])]
>>> for typecode, initializer in argslist:
	a = array(typecode, initializer)
	print a, '\tSize =', a.buffer_info()[1] * a.itemsize
	del a

	
array('l') 	Size = 0
array('c', 'hello world') 	Size = 11
array('u', u'hello \u2641') 	Size = 14
array('l', [1, 2, 3, 4, 5]) 	Size = 20
array('d', [1.0, 2.0, 3.1400000000000001]) 	Size = 24
>>>
