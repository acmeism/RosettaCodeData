function is_prime(n,	p)
{
        if (!(n%2) || !(n%3)) {
		return 0 }
        p = 1
        while(p*p < n)
                if (n%(p += 4) == 0 || n%(p += 2) == 0) {
                        return 0 }
        return 1
}

function reverse(n,	r)
{
	r = 0
        for (r = 0; int(n) != 0; n /= 10)
                r = r*10 + int(n%10);
        return r
}

function is_emirp(n,   r)
{
        r = reverse(n)
	return ((r != n) && is_prime(n) && is_prime(r)) ? 1 : 0
}

BEGIN {
	c = 0
	for (x = 11; c < 20; x += 2) {
		if (is_emirp(x)) {
			printf(" %i,", x); ++c }
	}
	printf("\n")
	for (x = 7701; x < 8000; x += 2) {
		if (is_emirp(x)) {
			printf(" %i,", x); ++c }
	}
	printf("\n")
	c = 0
	for (x = 11; ; x += 2)
                        if (is_emirp(x) && ++c == 10000) {
                                printf(" %i", x);
                                break;
                        }
	printf("\n")
}
