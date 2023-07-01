# Sieve of Eratosthenes: Echoes all prime numbers through $limit.
@ limit = 80

if ( ( $limit * $limit ) / $limit != $limit ) then
	echo limit is too large, would cause integer overflow.
	exit 1
endif

# Use $prime[2], $prime[3], ..., $prime[$limit] as array of booleans.
# Initialize values to 1 => yes it is prime.
set prime=( `repeat $limit echo 1` )

# Find and echo prime numbers.
@ i = 2
while ( $i <= $limit )
	if ( $prime[$i] ) then
		echo $i

		# For each multiple of i, set 0 => no it is not prime.
		# Optimization: start at i squared.
		@ m = $i * $i
		while ( $m <= $limit )
			set prime[$m] = 0
			@ m += $i
		end
	endif
	@ i += 1
end
