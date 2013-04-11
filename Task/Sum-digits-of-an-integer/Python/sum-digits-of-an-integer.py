def toBaseX(num, base):
	output = []
	index = 0
	while num:
		num, rem = divmod(num, base)
		output.append(str(rem))
	return output

def sumDigits( *args ):
	if len(args) == 1:
		number = str(args[0])
	else:
		num = args[0]
		base = args[1]
		if base < 2:
			print "Base must be between 2 and 36"
			exit(1)
		if num < base or num == base:
			number = str(num)
		else:
			number = toBaseX(num,base)
		
	sumVal = 0
	for x in number:
		sumVal += int(x)
	return sumVal

print sumDigits(1)
print sumDigits(12345)
print sumDigits(123045)
print sumDigits(0xfe, 16)
print sumDigits(0xf0e, 16)
