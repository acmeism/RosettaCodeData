BEGIN {
	# This requires 1e400 to overflow to infinity.
	nzero = -0
	nan  = 0 * 1e400
	pinf = 1e400
	ninf = -1e400

	print "nzero =", nzero
	print "nan =", nan
	print "pinf =", pinf
	print "ninf =", ninf
	print

	# When y == 0, sign of x decides if atan2(y, x) is 0 or pi.
	print "atan2(0, 0) =", atan2(0, 0)
	print "atan2(0, pinf) =", atan2(0, pinf)
	print "atan2(0, nzero) =", atan2(0, nzero)
	print "atan2(0, ninf) =", atan2(0, ninf)
	print

	# From least to most: ninf, -1e200, 1e200, pinf.
	print "ninf * -1 =", ninf * -1
	print "pinf * -1 =", pinf * -1
	print "-1e200 > ninf?", (-1e200 > ninf) ? "yes" : "no"
	print "1e200 < pinf?", (1e200 < pinf) ? "yes" : "no"
	print

	# NaN spreads from input to output.
	print "nan test:", (1 + 2 * 3 - 4) / (-5.6e7 + nan)

	# NaN never equals anything. These tests should print "no".
	print "nan == nan?", (nan == nan) ? "yes" : "no"
	print "nan == 42?", (nan == 42) ? "yes" : "no"
}
