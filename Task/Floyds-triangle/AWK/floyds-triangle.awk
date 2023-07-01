#!/bin/awk -f

BEGIN {
	if (rows !~ /^[0-9]+$/ || rows < 0) {
		print "invalid rows or missing from command line"
		print "syntax: awk -v rows=14 -f floyds_triangle.awk"
		exit 1
	}

	for (row=cols=1; row<=rows; row++ cols++) {
		width[row] = length(row + (rows * (rows-1))/2)
		for (col=1; col<=cols; col++)
			printf("%*d%c", width[col], ++n, row == col ? "\n" : " ")
	}
}
