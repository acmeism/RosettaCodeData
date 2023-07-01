import math

def SquareFree ( _number ) :
	max = (int) (math.sqrt ( _number ))

	for root in range ( 2, max+1 ):					# Create a custom prime sieve
		if 0 == _number % ( root * root ):
			return False

	return True

def ListSquareFrees( _start, _end ):
	count = 0
	for i in range ( _start, _end+1 ):
		if True == SquareFree( i ):
			print ( "{}\t".format(i), end="" )
			count += 1

	print ( "\n\nTotal count of square-free numbers between {} and {}: {}".format(_start, _end, count))

ListSquareFrees( 1, 100 )
ListSquareFrees( 1000000000000, 1000000000145 )
