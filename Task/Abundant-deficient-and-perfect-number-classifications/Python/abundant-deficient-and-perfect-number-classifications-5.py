pn = 0
an = 0
dn = 0
tt = []
num = 20000
for n in range(1, num+1):
	for x in range(1,1+n//2):
		if n%x == 0:
			tt.append(x)
	if sum(tt) == n:
		pn += 1
	elif sum(tt) > n:
		an += 1
	elif sum(tt) < n:
		dn += 1
	tt = []

print(str(pn) + " Perfect Numbers")
print(str(an) + " Abundant Numbers")
print(str(dn) + " Deficient Numbers")
