#!/usr/bin/gawk -Mf
function left_factorial(num) {
	result=0
	adder=1
	if (num==0) return(0)
	for (k = 1; k <=num; k++) {
		result = result + adder
		adder = adder * k
	}
	return(result)
}

BEGIN {
	for (i = 0; i <= 10; i++) {
		print "!" i " = " left_factorial(i)
	}
	for (i = 20; i<= 110; i+=10) {
		print "!" i " = " left_factorial(i)
	}
	for (i = 1000; i<= 10000; i+=1000) {
		print "!" i " has " length(left_factorial(i)) " digits"
	}
      }
