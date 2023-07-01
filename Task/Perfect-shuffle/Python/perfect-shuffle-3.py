def mul_ord2(n):
	# directly calculate how many shuffles are needed to restore
	# initial order: 2^o mod(n-1) == 1
	if n == 2: return 1

	n,t,o = n-1,2,1
	while t != 1:
		t,o = (t*2)%n,o+1
	return o

def shuffles(n):
	a,c = list(range(n)), 0
	b = a

	while True:
		# Reverse shuffle; a[i] can be taken as the current
		# position of the card with value i.  This is faster.
		a = a[0:n:2] + a[1:n:2]
		c += 1
		if b == a: break
	return c

for n in range(2, 10000, 2):
	#print(n, mul_ord2(n))
	print(n, shuffles(n))
