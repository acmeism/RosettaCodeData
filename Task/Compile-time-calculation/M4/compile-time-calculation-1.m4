define(`factorial',
`ifelse($1, 0, 1, `eval($1 * factorial(eval($1 - 1)))')')dnl
dnl
BEGIN {
	print "10! is factorial(10)"
}
