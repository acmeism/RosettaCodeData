count = 32
? "First " + count + " Riordan numbers:"
temp = 1
temp1 = 0
? temp
? temp1
lin = 0
for n = 2 to count - 1
	a = (n - 1) * (2 * temp1 + 3 * temp) / (n + 1)
    see "" + a + " "
	lin = lin + 1
	if lin%5 = 0
		see nl
	ok
    temp = temp1
    temp1 = a
next

