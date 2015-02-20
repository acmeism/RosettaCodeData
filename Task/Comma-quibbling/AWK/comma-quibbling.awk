function quibble(a, n,    i, s) {
	for (i = 1; i < n - 1; i++) s = s a[i] ", "
	i = n - 1; if (i > 0) s = s a[i] " and "
	if (n > 0) s = s a[n]
	return "{" s "}"
}

BEGIN {
	print quibble(a, 0)
	n = split("ABC", b); print quibble(b, n)
	n = split("ABC DEF", c); print quibble(c, n)
	n = split("ABC DEF G H", d); print quibble(d, n)
}
