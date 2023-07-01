def bags(n,cache={}):
	if not n: return [(0, "")]

	upto = sum([bags(x) for x in range(n-1, 0, -1)], [])
	return [(c+1, '('+s+')') for c,s in bagchain((0, ""), n-1, upto)]

def bagchain(x, n, bb, start=0):
	if not n: return [x]

	out = []
	for i in range(start, len(bb)):
		c,s = bb[i]
		if c <= n: out += bagchain((x[0] + c, x[1] + s), n-c, bb, i)
	return out

# Maybe this lessens eye strain. Maybe not.
def replace_brackets(s):
	depth,out = 0,[]
	for c in s:
		if c == '(':
			out.append("([{"[depth%3])
			depth += 1
		else:
			depth -= 1
			out.append(")]}"[depth%3])
	return "".join(out)

for x in bags(5): print(replace_brackets(x[1]))
