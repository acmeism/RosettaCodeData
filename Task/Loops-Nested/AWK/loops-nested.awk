BEGIN {
	rows = 5
	columns = 5

	# Fill ary[] with random numbers from 1 to 20.
	for (r = 1; r <= rows; r++) {
		for (c = 1; c <= columns; c++)
			ary[r, c] = int(rand() * 20) + 1
	}

	# Find a 20.
	b = 0
	for (r = 1; r <= rows; r++) {
		for (c = 1; c <= columns; c++) {
			v = ary[r, c]
			printf " %2d", v
			if (v == 20) {
				print
				b = 1
				break
			}
		}
		if (b) break
		print
	}
}
