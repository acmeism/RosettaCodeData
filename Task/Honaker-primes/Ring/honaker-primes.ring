load "stdlibcore.ring"

nr = 0
lin = 0
Prim = []
for n = 1 to 6653
	if isprime(n)
		add(Prim,n)
	ok
next

for m = 1 to 6653
	ind = find(Prim,m)
    res(m,ind)
next

func res(m,ind)
	sum1 = 0
	sum2 = 0
	sm = string(m)
	for p = 1 to len(sm)
		sum1 = sum1 + sm[p]
	next
	si = string(ind)
	for q = 1 to len(si)
		sum2 = sum2 + si[q]
	next
	if sum1 = sum2
		nr++
		if lin % 5 = 0
			see nl
		ok
		? "(" + nr + ", " + ind + ", " + m + ")"
		lin++
	ok
	return
