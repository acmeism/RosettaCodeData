limiter = 100
primelist = []
def primer(n):
	for d in primelist:
		if d * d > n:
			break
		if n % d == 0:
			return
	primelist.append(n)

for vv in range(2, limiter):
	primer(vv)

print(len(primelist))
print(*primelist)
