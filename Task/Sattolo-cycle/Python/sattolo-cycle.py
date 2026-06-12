>>> from random import randrange
>>> def sattoloCycle(items):
	for i in range(len(items) - 1, 0, -1):
		j = randrange(i)  # 0 <= j <= i-1
		items[j], items[i] = items[i], items[j]

		
>>> # Tests
>>> for _ in range(10):
	lst = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
	sattoloCycle(lst)
	print(lst)

	
[5, 8, 1, 2, 6, 4, 3, 9, 10, 7]
[5, 9, 8, 10, 4, 3, 6, 2, 1, 7]
[10, 5, 8, 3, 9, 1, 4, 2, 6, 7]
[10, 5, 2, 6, 9, 7, 8, 3, 1, 4]
[7, 4, 8, 5, 10, 3, 2, 9, 1, 6]
[2, 3, 10, 9, 4, 5, 8, 1, 7, 6]
[5, 7, 4, 6, 2, 9, 3, 10, 8, 1]
[3, 10, 7, 2, 9, 5, 8, 4, 1, 6]
[2, 6, 5, 3, 9, 8, 10, 7, 1, 4]
[3, 6, 2, 5, 10, 4, 1, 9, 7, 8]
>>>
