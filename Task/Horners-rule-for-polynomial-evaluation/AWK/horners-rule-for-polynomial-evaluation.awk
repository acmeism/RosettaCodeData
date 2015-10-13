#!/usr/bin/awk -f
function horner(x, A) {
	acc = 0;	
	for (i = length(A); 0<i; i--) {
		acc = acc*x + A[i];
	}
	return acc;
}
BEGIN {
        split(p,P);
	print horner(x,P);
}
