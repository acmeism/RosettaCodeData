primep() {
	set -- "$1" 3
	test "$1" -eq 2 && return 0		# 2 is prime.
	expr "$1" \% 2 >/dev/null || return 1	# Other evens are not prime.
	test "$1" -ge 3 || return 1

	# Loop for odd p from 3 to sqrt(n).
	# Comparing p * p <= n can overflow. We use p <= n / p.
	while expr $2 \<= "$1" / $2 >/dev/null; do
		# If p divides n, then n is not prime.
		expr "$1" % $2 >/dev/null || return 1
		set -- "$1" `expr $2 + 2`
	done
	return 0	# Yes, n is prime.
}
