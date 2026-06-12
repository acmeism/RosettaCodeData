load "stdlibcore.ring"
limit = 2213
power = 12
Polig = []
for num = 1 to limit step 2
	for p = 0 to power
		pp = pow(2,p)
		ppm = num - pp
   		if ppm > 0 and isprime(ppm)
			add(Polig,num)
		ok
	next
next
sPolig = sort(Polig)

lin = 0
for m = 1 to limit step 2
	ind = find(sPolig,m)
	if ind = 0
      	if lin % 5 = 0
			see nl
		ok
		see "" + m + " "
		lin++
	ok
next
