def numsum(n):
	''' The recursive sum of all digits in a number
        unit a single character is obtained'''
	res = sum([int(i) for i in str(n)])
	if res < 10: return res
	else : return numsum(res)
	
for n in range(1,101):
	response = 'Fizz'*(numsum(n) in [3,6,9]) + \
                   'Buzz'*(str(n)[-1] in ['5','0'])\
	            or n
	print(response)
