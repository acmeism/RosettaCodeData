from sympy import sieve # library for primes

def get_pfct(n):
	i = 2; factors = []
	while i * i <= n:
		if n % i:
			i += 1
		else:
			n //= i
			factors.append(i)
	if n > 1:
		factors.append(n)
	return len(factors)

sieve.extend(110) # first 110 primes...
primes=sieve._list

pool=[]

for each in xrange(0,121):
	pool.append(get_pfct(each))

for i,each in enumerate(pool):
	if each in primes:
		print i,
