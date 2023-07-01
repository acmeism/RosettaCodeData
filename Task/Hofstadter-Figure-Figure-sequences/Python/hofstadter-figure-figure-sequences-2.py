cR = [1]
cS = [2]

def extend_RS():
	x = cR[len(cR) - 1] + cS[len(cR) - 1]
	cR.append(x)
	cS += range(cS[-1] + 1, x)
	cS.append(x + 1)

def ff_R(n):
	assert(n > 0)
	while n > len(cR): extend_RS()
	return cR[n - 1]

def ff_S(n):
	assert(n > 0)
	while n > len(cS): extend_RS()
	return cS[n - 1]

# tests
print([ ff_R(i) for i in range(1, 11) ])

s = {}
for i in range(1, 1001): s[i] = 0
for i in range(1, 41):  del s[ff_R(i)]
for i in range(1, 961): del s[ff_S(i)]

# the fact that we got here without a key error
print("Ok")
