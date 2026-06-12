from fractions import Fraction

def gauss(m):
	n, p = len(m), len(m[0])
	for i in range(n):
		k = max(range(i, n), key = lambda x: abs(m[x][i]))
		m[i], m[k] = m[k], m[i]
		t = 1 / m[i][i]
		for j in range(i + 1, p): m[i][j] *= t
		for j in range(i + 1, n):
			t = m[j][i]
			for k in range(i + 1, p): m[j][k] -= t * m[i][k]
	for i in range(n - 1, -1, -1):
		for j in range(i): m[j][-1] -= m[j][i] * m[i][-1]
	return [row[-1] for row in m]

def network(n,k0,k1,s):
	m = [[0] * (n+1) for i in range(n)]
	resistors = s.split('|')
	for resistor in resistors:
		a,b,r = resistor.split(' ')
		a,b,r = int(a), int(b), Fraction(1,int(r))
		m[a][a] += r
		m[b][b] += r
		if a > 0: m[a][b] -= r
		if b > 0: m[b][a] -= r
	m[k0][k0] = Fraction(1, 1)
	m[k1][-1] = Fraction(1, 1)
	return gauss(m)[k1]

assert 10             == network(7,0,1,"0 2 6|2 3 4|3 4 10|4 5 2|5 6 8|6 1 4|3 5 6|3 6 6|3 1 8|2 1 8")
assert 3/2            == network(3*3,0,3*3-1,"0 1 1|1 2 1|3 4 1|4 5 1|6 7 1|7 8 1|0 3 1|3 6 1|1 4 1|4 7 1|2 5 1|5 8 1")
assert Fraction(13,7) == network(4*4,0,4*4-1,"0 1 1|1 2 1|2 3 1|4 5 1|5 6 1|6 7 1|8 9 1|9 10 1|10 11 1|12 13 1|13 14 1|14 15 1|0 4 1|4 8 1|8 12 1|1 5 1|5 9 1|9 13 1|2 6 1|6 10 1|10 14 1|3 7 1|7 11 1|11 15 1")
assert 180            == network(4,0,3,"0 1 150|0 2 50|1 3 300|2 3 250")
