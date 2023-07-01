def partial(f, g):
	def fg(*x): return f(g, *x)
	return fg

def fs(f, *x): return [ f(a) for a in x]
def f1(a): return a * 2
def f2(a): return a * a

fsf1 = partial(fs, f1)
fsf2 = partial(fs, f2)

print fsf1(1, 2, 3, 4)
print fsf2(1, 2, 3, 4)
