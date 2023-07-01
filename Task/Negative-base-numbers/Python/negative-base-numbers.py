#!/bin/python
from __future__ import print_function

def EncodeNegBase(n, b): #Converts from decimal
	if n == 0:
		return "0"
	out = []
	while n != 0:
		n, rem = divmod(n, b)
		if rem < 0:
			n += 1
			rem -= b
		out.append(rem)
	return "".join(map(str, out[::-1]))

def DecodeNegBase(nstr, b): #Converts to decimal
	if nstr == "0":
		return 0
	
	total = 0
	for i, ch in enumerate(nstr[::-1]):
		total += int(ch) * b**i
	return total

if __name__=="__main__":
	
	print ("Encode 10 as negabinary (expect 11110)")
	result = EncodeNegBase(10, -2)
	print (result)
	if DecodeNegBase(result, -2) == 10: print ("Converted back to decimal")
	else: print ("Error converting back to decimal")

	print ("Encode 146 as negaternary (expect 21102)")
	result = EncodeNegBase(146, -3)
	print (result)
	if DecodeNegBase(result, -3) == 146: print ("Converted back to decimal")
	else: print ("Error converting back to decimal")

	print ("Encode 15 as negadecimal (expect 195)")
	result = EncodeNegBase(15, -10)
	print (result)
	if DecodeNegBase(result, -10) == 15: print ("Converted back to decimal")
	else: print ("Error converting back to decimal")
