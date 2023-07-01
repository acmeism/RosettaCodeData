# gives one solution of (x,y) for a x + by = c
def dioph(a, b, c):
	aa,bb,x,y = a, b, 0, 1

	while True:
		q,a,b = a//b, b, a%b
		x,y = y - q*x, x
		if abs(a) == 1: break

	if y*aa % bb != 1: y = -y
	x,y = y*c, (c - aa*y*c)//bb
	#assert(x*aa + y*bb == c)
	return x,y

# rems: what monkey got each turn
# min_share: each sailor needs to get at least this many in the final round
def calcnuts(rems, min_share = 0):
	n, r = len(rems) - 1, 0
	c = (n - 1)**n
	for x in rems: r,c = r + x*c, c//(n-1)*n

	a, b = (n-1)**n, n**(n+1)
	x, y = dioph(a, -b, r)
	k = (min_share - y + a - 1)//a
	return x + k*b, y + k*a

def distribute(nuts, monkey_nuts):
	n = len(monkey_nuts) - 1
	print("\n%d sailors, %d nuts:"%(n, nuts))
	for r in monkey_nuts[:-1]:
		p = (nuts - r)//n
		print("\tNuts %d, hide %d, monkey gets %d" % (nuts, p, r))
		nuts = p*(n - 1)

	r = monkey_nuts[-1]
	p = (nuts - r)//n
	print("Finally:\n\tNuts %d, each share %d, monkey gets %d" % (nuts, p, r))

for sailors in range(2, 10):
	monkey_loot = [1]*sailors + [0]
	distribute(calcnuts(monkey_loot, 1)[0], monkey_loot)

# many sailors, many nuts
#for i in range(1, 5): print(10**i, calcnuts([1]*10**i + [0])[0])
