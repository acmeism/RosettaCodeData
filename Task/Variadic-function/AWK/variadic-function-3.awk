function g(len, ary,    i) {
	for (i = 1; i <= len; i++) print ary[i];
}

BEGIN {
	c = split("Line 1:Line 2:Next line is empty::Last line", a, ":")
	g(c, a)		# Pass a[1] = "Line 1", a[4] = "", ...

}
