from itertools import islice

def R():
	n = 1
	yield n
	for s in S():
		n += s
		yield n;

def S():
	yield 2
	yield 4
	u = 5
	for r in R():
		if r <= u: continue;
		for x in range(u, r): yield x
		u = r + 1

def lst(s, n): return list(islice(s(), n))

print "R:", lst(R, 10)
print "S:", lst(S, 10)
print sorted(lst(R, 40) + lst(S, 960)) == list(range(1,1001))

# perf test case
# print sum(lst(R, 10000000))
