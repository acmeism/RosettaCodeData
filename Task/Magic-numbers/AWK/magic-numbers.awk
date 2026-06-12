function lmod(n, d,	i, l, r) {
	l = 15 - length(d - 1)
	for (i = 1; i <= d; i += l) r = (r substr(n, i, l)) % d
	return r
}

function is_pandigital(d, n) {
	while (d < 10) if (!index(n, d++)) return 0
	return 1
}

BEGIN {
	do {
		l = length(n = res[++i]) + 1
		for (d = (l - lmod(n "0", l)) % l; d < 10; d += l)
			res[++o] = n d
	} while (i != o)

	print "found " o " magic numbers"
	print "the largest one is " res[o]

	print "count by number of digits:"
	l = 0
	for (i = 1; i <= o; ++i) {
		if ((d = length(m = res[i])) == l) {
			++n
		} else {
			if (l) printf "%u:%u ", l, n
			n = 1
			l = d
		}
		if (l == 9 && is_pandigital(1, m))
			pd1 = pd1 " " m
		if (l == 10 && is_pandigital(0, m))
			pd0 = pd0 " " m
	}
	printf "%u:%u\n", l, n
	print "minimally pandigital in 1..9:" pd1
	print "minimally pandigital in 0..9:" pd0
}
