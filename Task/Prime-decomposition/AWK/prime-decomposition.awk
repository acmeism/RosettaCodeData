function pfac(n,    r, f){
	r = ""; f = 2
	while (f <= n) {
		while(!(n % f)) {
			n = n / f
			r = r " " f
		}
		f = f + 2 - (f == 2)
	}
	return r
}

# For each line of input, print the prime factors.
{ print pfac($1) }
