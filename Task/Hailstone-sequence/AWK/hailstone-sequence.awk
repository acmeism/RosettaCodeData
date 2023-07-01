#!/usr/bin/awk -f
function hailstone(v, verbose) {
	n = 1;
	u = v;
	while (1) {
		if (verbose) printf " "u;
		if (u==1) return(n);
		n++;
		if (u%2 > 0 )
			u = 3*u+1;
		else
			u = u/2;
	}
}

BEGIN {
	i = 27;
	printf("hailstone(%i) has %i elements\n",i,hailstone(i,1));
	ix=0;
	m=0;
	for (i=1; i<100000; i++) {
		n = hailstone(i,0);
		if (m<n) {
			m=n;
			ix=i;
		}
	}
	printf("longest hailstone sequence is %i and has %i elements\n",ix,m);
}
