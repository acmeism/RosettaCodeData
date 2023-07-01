def rank(x): return int('a'.join(map(str, [1] + x)), 11)

def unrank(n):
	s = ''
	while n: s,n = "0123456789a"[n%11] + s, n//11
	return map(int, s.split('a'))[1:]

l = [1, 2, 3, 10, 100, 987654321]
print l
n = rank(l)
print n
l = unrank(n)
print l
