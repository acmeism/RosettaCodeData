# Shuffle an _array_ with indexes from 1 to _len_.
function shuffle(array, len,    i, j, t) {
	for (i = len; i > 1; i--) {
		# j = random integer from 1 to i
		j = int(i * rand()) + 1

		# swap array[i], array[j]
		t = array[i]
		array[i] = array[j]
		array[j] = t
	}
}

# Test program.
BEGIN {
	len = split("11 22 33 44 55 66 77 88 99 110", array)
	shuffle(array, len)

	for (i = 1; i < len; i++) printf "%s ", array[i]
	printf "%s\n", array[len]
}
