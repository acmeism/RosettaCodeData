BEGIN {
	E = exp(1)
	PI = atan2(0, -1)
}

function abs(x) {
	return x < 0 ? -x : x
}

function floor(x) {
	y = int(x)
	return y > x ? y - 1 : y
}

function ceil(x) {
	y = int(x)
	return y < x ? y + 1 : y
}

BEGIN {
	print E
	print PI
	print abs(-3.4)		# absolute value
	print floor(-3.4)	# floor
	print ceil(-3.4)	# ceiling
}
# outputs 2.71828, 3.14159, 3.4, -4, -3
