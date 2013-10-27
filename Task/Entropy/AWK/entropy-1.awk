#!/usr/bin/awk -f
{
	for (i=1; i<= length($0); i++) {
		H[substr($0,i,1)]++;
		N++;
	}
}

END {
	for (i in H) {
		p = H[i]/N;
		E -=  p * log(p);
	}
	print E/log(2);
}
