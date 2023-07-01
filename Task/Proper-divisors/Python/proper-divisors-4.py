def pd(num):
	factors = []
	for divisor in range(1,1+num//2):
		if num % divisor == 0: factors.append(divisor)
	return factors

def pdc(num):
	count = 0
	for divisor in range(1,1+num//2):
		if num % divisor == 0: count += 1
	return count

def fmtres(title, lmt, best, bestc):
	return "The " + title + " number up to and including " + str(lmt) + " with the highest number of proper divisors is " + str(best) + ", which has " + str(bestc)

def showcount(limit):
	best, bestc, bh, bhc = 0, 0, 0, 0
	for i in range(limit+1):
		divc = pdc(i)
		if divc > bestc: bestc, best = divc, i
		if divc >= bhc: bhc, bh = divc, i
	if best == bh:
		print(fmtres("only", limit, best, bestc))
	else:
		print(fmtres("lowest", limit, best, bestc))
		print(fmtres("highest", limit, bh, bhc))
	print()

lmt = 10
for i in range(1, lmt + 1):
	divs = pd(i)
	if len(divs) == 0:
		print("There are no proper divisors of", i)
	elif len(divs) == 1:
		print(divs[0], "is the only proper divisor of", i)
	else:
		print(divs, "are the proper divisors of", i)
print()
showcount(20000)
showcount(25000)
