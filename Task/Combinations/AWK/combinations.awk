BEGIN {
	## Default values for r and n (Choose 3 from pool of 5).  Can
	## alternatively be set on the command line:-
	## awk -v r=<number of items being chosen> -v n=<how many to choose from> -f <scriptname>
	if (length(r) == 0) r = 3
	if (length(n) == 0) n = 5

	for (i=1; i <= r; i++) { ## First combination of items:
		A[i] = i
		if (i < r ) printf i OFS
		else print i}

	## While 1st item is less than its maximum permitted value...
	while (A[1] < n - r + 1) {
		## loop backwards through all items in the previous
		## combination of items until an item is found that is
		## less than its maximum permitted value:
		for (i = r; i >= 1; i--) {
			## If the equivalently positioned item in the
			## previous combination of items is less than its
			## maximum permitted value...
			if (A[i] < n - r + i) {
				## increment the current item by 1:
				A[i]++
				## Save the current position-index for use
				## outside this "for" loop:
				p = i
				break}}
		## Put consecutive numbers in the remainder of the array,
		## counting up from position-index p.
		for (i = p + 1; i <= r; i++) A[i] = A[i - 1] + 1

		## Print the current combination of items:
		for (i=1; i <= r; i++) {
			if (i < r) printf A[i] OFS
			else print A[i]}}
	exit}
