crt = (n,a) ->
	sum = 0
	prod = n.reduce (a,c) -> a*c
	for [ni,ai] in _.zip n,a
		p = prod // ni
		sum += ai * p * mulInv p,ni
	sum % prod
	
mulInv = (a,b) ->
	b0 = b
	[x0,x1] = [0,1]
	if b==1 then return 1
	while a > 1
		q = a // b
		[a,b] = [b, a % b]
		[x0,x1] = [x1-q*x0, x0]
	if x1 < 0 then x1 += b0
	x1
	
print crt [3,5,7], [2,3,2]
