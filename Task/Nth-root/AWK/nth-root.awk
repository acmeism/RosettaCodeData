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

function nthroot(y,n) {
        eps = 1e-15;   # relative accuracy
        x   = 1;
	do {
		d  = ( y / ( x^(n-1) ) - x ) / n ;
		x += d;
		e = eps*x;   # absolute accuracy	
	} while ( d < -e  || d > e )

	return x
}
