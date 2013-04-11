#!/usr/bin/awk -f
BEGIN {
    A[1] = 49927398716;
    A[2] = 49927398717;
    A[3] = 1234567812345678;
    A[4] = 1234567812345670;
    for (k in A) print "isLuhn("A[k]"): ",isLuhn(A[k]);	
}

function isLuhn(cardno) {
    m = "246813579";
    n = length(cardno);
    for (k = n; 0 < k; k -= 2) {
	s += substr(cardno, k, 1);
    }
    for (k = n-1; 0 < k; k -= 2) {
	s += substr(m, substr(cardno, k, 1), 1);
    }
    return ((s%10)==0);	
}
