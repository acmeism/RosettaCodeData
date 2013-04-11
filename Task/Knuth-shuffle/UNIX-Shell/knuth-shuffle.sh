# Shuffle array[@].
function shuffle {
	integer i j t

	((i = ${#array[@]}))
	while ((i > 1)); do
		((j = RANDOM))                 # 0 <= j < 32768
		((j < 32768 % i)) && continue  # no modulo bias
		((j %= i))                     # 0 <= j < i

		((i -= 1))
		((t = array[i]))
		((array[i] = array[j]))
		((array[j] = t))
	done
}


# Test program.
set -A array 11 22 33 44 55 66 77 88 99 110
shuffle
echo "${array[@]}"
