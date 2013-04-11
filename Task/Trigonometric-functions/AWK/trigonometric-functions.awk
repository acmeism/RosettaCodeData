# tan(x) = tangent of x
function tan(x) {
	return sin(x) / cos(x)
}

# asin(y) = arcsine of y, domain [-1, 1], range [-pi/2, pi/2]
function asin(y) {
	return atan2(y, sqrt(1 - y * y))
}

# acos(x) = arccosine of x, domain [-1, 1], range [0, pi]
function acos(x) {
	return atan2(sqrt(1 - x * x), x)
}

# atan(y) = arctangent of y, range (-pi/2, pi/2)
function atan(y) {
	return atan2(y, 1)
}

BEGIN {
	pi = atan2(0, -1)
	degrees = pi / 180

	print "Using radians:"
	print "  sin(-pi / 6) =", sin(-pi / 6)
	print "  cos(3 * pi / 4) =", cos(3 * pi / 4)
	print "  tan(pi / 3) =", tan(pi / 3)
	print "  asin(-1 / 2) =", asin(-1 / 2)
	print "  acos(-sqrt(2) / 2) =", acos(-sqrt(2) / 2)
	print "  atan(sqrt(3)) =", atan(sqrt(3))

	print "Using degrees:"
	print "  sin(-30) =", sin(-30 * degrees)
	print "  cos(135) =", cos(135 * degrees)
	print "  tan(60) =", tan(60 * degrees)
	print "  asin(-1 / 2) =", asin(-1 / 2) / degrees
	print "  acos(-sqrt(2) / 2) =", acos(-sqrt(2) / 2) / degrees
	print "  atan(sqrt(3)) =", atan(sqrt(3)) / degrees
}
