# Joins the elements ary[1] to ary[len] in a string.
function join(ary, len,    i, s) {
	s = "["
	for (i = 1; i <= len; i++) {
		s = s ary[i]
		if (i < len)
			s = s ", "
	}
	s = s "]"
	return s
}

# Demonstrates maxsubseq().
function try(str,    ary, len, max, maxlen) {
	len = split(str, ary)
	print "Array: " join(ary, len)
	maxlen = maxsubseq(max, ary, len)
	print "  Maximal subsequence: " \
	    join(max, maxlen) ", sum " max["sum"]
}

BEGIN {
	try("-1 -2 -3 -4 -5")
	try("0 1 2 -3 3 -1 0 -4 0 -1 -4 2")
	try("-1 -2 3 5 6 -2 -1 4 -4 2 -1")
}
