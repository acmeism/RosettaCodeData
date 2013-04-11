function primes {
	typeset a i=2 j m=$1
	# No for (( ... )) loop in pdksh. Use while loop.
	while (( i <= m )); do
		a[$i]=$i
		(( i++ ))
	done

	i=2
	while (( j = i * i, j <= m )); do
		if [[ -n ${a[$i]} ]]; then
			while (( j <= m )); do
				unset a[$j]
				(( j += i ))
			done
		fi
		(( i++ ))
	done
	# No print command in bash. Use echo command.
	echo ${a[*]}
}

primes 1000
