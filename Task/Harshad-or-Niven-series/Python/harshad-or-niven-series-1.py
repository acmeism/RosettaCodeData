>>> import itertools
>>> def harshad():
	for n in itertools.count(1):
		if n % sum(int(ch) for ch in str(n)) == 0:
			yield n

		
>>> list(itertools.islice(harshad(), 0, 20))
[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 18, 20, 21, 24, 27, 30, 36, 40, 42]
>>> for n in harshad():
	if n > 1000:
		print(n)
		break

	
1002
>>>
