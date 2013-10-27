#!/usr/bin/awk -f
BEGIN {
	print (a(1) && b(1));
	print (a(1) || b(1));
	print (a(0) && b(1));
	print (a(0) || b(1));
}


function a(x) {
	print "  x:"x;
	return x;
}
function b(y) {
	print "  y:"y;
	return y;
}
