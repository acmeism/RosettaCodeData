function f(a, b, c){
	if (a != "") print a
	if (b != "") print b
	if (c != "") print c
}

BEGIN {
	print "[1 arg]"; f(1)
	print "[2 args]"; f(1, 2)
	print "[3 args]"; f(1, 2, 3)
}
