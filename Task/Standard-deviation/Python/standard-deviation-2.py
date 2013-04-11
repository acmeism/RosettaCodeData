>>> class SD(object): # Plain () for python 3.x
	def __init__(self):
		self.sum, self.sum2, self.n = (0,0,0)
	def sd(self, x):
		self.sum  += x
		self.sum2 += x*x
		self.n    += 1.0
		sum, sum2, n = self.sum, self.sum2, self.n
		return sqrt(sum2/n - sum*sum/n/n)

>>> sd_inst = SD()
>>> for value in (2,4,4,4,5,5,7,9):
	print (value, sd_inst.sd(value))
