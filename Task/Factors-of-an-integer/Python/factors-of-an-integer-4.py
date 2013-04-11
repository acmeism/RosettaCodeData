def factor(n):
	a, r = 1, [1]
	while a * a < n:
		a += 1
		if n % a: continue
		b, f = 1, []
		while n % a == 0:
			n //= a
			b *= a
			f += [i * b for i in r]
		r += f
	if n > 1: r += [i * n for i in r]
	return r
