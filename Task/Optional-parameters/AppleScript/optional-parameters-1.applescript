on sortTable(x)
	set {sortOrdering, sortColumn, sortReverse} to {sort_lexicographic, 1, false}
	try
		set sortOrdering to x's ordering
	end try
	try
		set sortColumn to x's column
	end try
	try
		set sortReverse to x's reverse
	end try
	return sortOrdering's sort(x's sequence, sortColumn, sortReverse)
end sortTable

script sort_lexicographic
	on sort(table, column, reverse)
		-- Implement lexicographic Sorting process here.
		return table
	end sort
end script
