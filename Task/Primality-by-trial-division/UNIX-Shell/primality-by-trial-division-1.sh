function primep {
	typeset n=$1 p=3
	(( n == 2 )) && return 0	# 2 is prime.
	(( n & 1 )) || return 1		# Other evens are not prime.
	(( n >= 3 )) || return 1

	# Loop for odd p from 3 to sqrt(n).
	# Comparing p * p <= n can overflow.
	while (( p <= n / p )); do
		# If p divides n, then n is not prime.
		(( n % p )) || return 1
		(( p += 2 ))
	done
	return 0	# Yes, n is prime.
}
