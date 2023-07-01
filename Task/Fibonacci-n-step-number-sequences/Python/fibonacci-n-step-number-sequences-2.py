>>> class Fiblike():
	def __init__(self, start):
		self.addnum = len(start)
		self.memo = start[:]
	def __call__(self, n):
		try:
			return self.memo[n]
		except IndexError:
			ans = sum(self(i) for i in range(n-self.addnum, n))
			self.memo.append(ans)
			return ans

		
>>> fibo = Fiblike([1,1])
>>> [fibo(i) for i in range(10)]
[1, 1, 2, 3, 5, 8, 13, 21, 34, 55]
>>> lucas = Fiblike([2,1])
>>> [lucas(i) for i in range(10)]
[2, 1, 3, 4, 7, 11, 18, 29, 47, 76]
>>> for n, name in zip(range(2,11), 'fibo tribo tetra penta hexa hepta octo nona deca'.split()) :
	fibber = Fiblike([1] + [2**i for i in range(n-1)])
	print('n=%2i, %5snacci -> %s ...' % (n, name, ' '.join(str(fibber(i)) for i in range(15))))

	
n= 2,  fibonacci -> 1 1 2 3 5 8 13 21 34 55 89 144 233 377 610 ...
n= 3, tribonacci -> 1 1 2 4 7 13 24 44 81 149 274 504 927 1705 3136 ...
n= 4, tetranacci -> 1 1 2 4 8 15 29 56 108 208 401 773 1490 2872 5536 ...
n= 5, pentanacci -> 1 1 2 4 8 16 31 61 120 236 464 912 1793 3525 6930 ...
n= 6,  hexanacci -> 1 1 2 4 8 16 32 63 125 248 492 976 1936 3840 7617 ...
n= 7, heptanacci -> 1 1 2 4 8 16 32 64 127 253 504 1004 2000 3984 7936 ...
n= 8,  octonacci -> 1 1 2 4 8 16 32 64 128 255 509 1016 2028 4048 8080 ...
n= 9,  nonanacci -> 1 1 2 4 8 16 32 64 128 256 511 1021 2040 4076 8144 ...
n=10,  decanacci -> 1 1 2 4 8 16 32 64 128 256 512 1023 2045 4088 8172 ...
>>>
