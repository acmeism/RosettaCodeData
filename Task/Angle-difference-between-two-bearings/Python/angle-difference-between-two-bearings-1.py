from __future__ import print_function

def getDifference(b1, b2):
	r = (b2 - b1) % 360.0
	# Python modulus has same sign as divisor, which is positive here,
	# so no need to consider negative case
	if r >= 180.0:
		r -= 360.0
	return r

if __name__ == "__main__":
	print ("Input in -180 to +180 range")
	print (getDifference(20.0, 45.0))
	print (getDifference(-45.0, 45.0))
	print (getDifference(-85.0, 90.0))
	print (getDifference(-95.0, 90.0))
	print (getDifference(-45.0, 125.0))
	print (getDifference(-45.0, 145.0))
	print (getDifference(-45.0, 125.0))
	print (getDifference(-45.0, 145.0))
	print (getDifference(29.4803, -88.6381))
	print (getDifference(-78.3251, -159.036))

	print ("Input in wider range")
	print (getDifference(-70099.74233810938, 29840.67437876723))
	print (getDifference(-165313.6666297357, 33693.9894517456))
	print (getDifference(1174.8380510598456, -154146.66490124757))
	print (getDifference(60175.77306795546, 42213.07192354373))
