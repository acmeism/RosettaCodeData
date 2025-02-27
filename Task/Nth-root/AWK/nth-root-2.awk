#!/usr/bin/awk -f
BEGIN {
    # test
	print nthroot(8,3)
	print nthroot(16,2)
	print nthroot(16,4)
	print nthroot(125,3)
	print nthroot(3,3)
	print nthroot(3,2)
}

function nthroot(a, n,   x, y, a_n, n1_n) {
	# no need for eps, the values are monotonically decreasing
	# until the root is found (if the initial value is above the root)
    x = 1 + a / n 				# starting value above the root
    a_n = a/n					# precompute loop invariants
    n1_n = (n - 1) / n
	do {
		y = x
		x  = n1_n * x + a_n / x^(n-1)
	}  while (x < y)
	# no harm to use average if x = y
	return (x + y) / 2
}
