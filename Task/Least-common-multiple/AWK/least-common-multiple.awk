# greatest common divisor
function gcd(m, n,    t) {
	# Euclid's method
	while (n != 0) {
		t = m
		m = n
		n = t % n
	}
	return m
}

# least common multiple
function lcm(m, n,    r) {
	if (m == 0 || n == 0)
		return 0
	r = m * n / gcd(m, n)
	return r < 0 ? -r : r
}

# Read two integers from each line of input.
# Print their least common multiple.
{ print lcm($1, $2) }
