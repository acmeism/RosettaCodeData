function f(a, b, c) {
	if (a != "") print a
	if (b != "") print b
	if (c != "") print c
}

BEGIN {
	# Set ary[1] and ary[2] at runtime.
	split("Line 1:Line 2", ary, ":")

	# Pass to f().
	f(ary[1], ary[2], ary[3])
}
