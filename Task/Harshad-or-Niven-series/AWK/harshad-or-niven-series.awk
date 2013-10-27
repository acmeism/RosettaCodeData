#!/usr/bin/awk -f
BEGIN {
	k=0; n=0;
	printf("First twenty Harshad numbers are:\n   ");
	while (k<20) {
		if (isharshad(++n)) {
			printf("%i ",n);
			++k;
		}
	}
	n = 1000;
	while (!isharshad(++n));
	printf("\nFirst Harshad number larger than 1000 is \n   %i\n",n);
}

function isharshad(n) {
	s = 0;
	for (i=0; i<length(n); ) {
		s+=substr(n,++i,1);
	}
	return !(n%s);
}
