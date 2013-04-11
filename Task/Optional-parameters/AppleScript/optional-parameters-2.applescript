-- Another sort function.
script sort_colex
	on sort(table, column, reverse)
		-- Implement colexicographic Sorting process here.
		return table
	end sort
end script

-- Populate a table (list) with data.
set table to {{1,2},{3,4}}

sortTable({sequence:table, ordering:sort_lexicographic, column:1, reverse:false})
sortTable({sequence:table, ordering:sort_colex, column:2, reverse:true})
sortTable({sequence:table, reverse:true})
sortTable({sequence:table})
