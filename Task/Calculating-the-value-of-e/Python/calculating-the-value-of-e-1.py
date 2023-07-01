import math
#Implementation of Brother's formula
e0 = 0
e = 2
n = 0
fact = 1
while(e-e0 > 1e-15):
	e0 = e
	n += 1
	fact *= 2*n*(2*n+1)
	e += (2.*n+2)/fact

print "Computed e = "+str(e)
print "Real e = "+str(math.e)
print "Error = "+str(math.e-e)
print "Number of iterations = "+str(n)
