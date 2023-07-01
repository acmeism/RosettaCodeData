from time import time
st = time()
pn, an, dn = 0, 0, 0
tt = []
num = 20000
for n in range(1, num + 1):
	for x in range(1, 1 + n // 2):
		if n % x == 0: tt.append(x)
	if sum(tt) == n: pn += 1
	elif sum(tt) > n: an += 1
	elif sum(tt) < n: dn += 1
	tt = []
et1 = time() - st
print(str(pn) + " Perfect Numbers")
print(str(an) + " Abundant Numbers")
print(str(dn) + " Deficient Numbers")
print(et1, "sec\n")

st = time()
pn, an, dn = 0, 0, 1
sum = 1
r = 1
num = 20000
for n in range(2, num + 1):
	d = r * r - n
	if d < 0: r += 1
	for x in range(2, r):
		if n % x == 0: sum += x + n // x
	if d == 0: sum += r
	if sum == n: pn += 1
	elif sum > n: an += 1
	elif sum < n: dn += 1
	sum = 1
et2 = time() - st
print(str(pn) + " Perfect Numbers")
print(str(an) + " Abundant Numbers")
print(str(dn) + " Deficient Numbers")
print(et2 * 1000, "ms\n")
print (et1 / et2,"times faster")
