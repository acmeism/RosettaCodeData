class
	SELECTION_SORT [G -> COMPARABLE]

feature {NONE}

	index_of_min (ar: ARRAY [G]; lower: INTEGER): INTEGER
			--Index of smallest element in 'ar' in the range of lower and the max index.
		require
			lower_positiv: lower >= 1
			lower_in_range: lower <= ar.count
			ar_not_void: ar /= Void
		local
			i: INTEGER
			min: G
		do
			from
				i := lower
				min := ar.item (i)
				Result := i
			until
				i + 1 > ar.count
			loop
				if ar.item (i + 1) < min then
					min := ar.item (i + 1)
					Result := i + 1
				end
				i := i + 1
			end
		ensure
			result_is_set: Result /= Void
		end

	sort (ar: ARRAY [G]): ARRAY [G]
			-- sort array ar with selectionsort
		require
			ar_not_void: ar /= Void
		local
			min_index: INTEGER
			ith: G
		do
			create Result.make_empty
			Result.deep_copy (ar)
			across
				Result as ic
			loop
				min_index := index_of_min (Result, ic.cursor_index)
				ith := Result [ic.cursor_index]
				Result [ic.cursor_index] := Result [min_index]
				Result [min_index] := ith
			end
		ensure
			Result_is_set: Result /= Void
			Result_sorted: is_sorted (Result) = True
		end

	is_sorted (ar: ARRAY [G]): BOOLEAN
			--- Is 'ar' sorted in ascending order?
		require
			ar_not_empty: ar.is_empty = False
		local
			i: INTEGER
		do
			Result := True
			from
				i := ar.lower
			until
				i = ar.upper
			loop
				if ar [i] > ar [i + 1] then
					Result := False
				end
				i := i + 1
			end
		end

feature

	selectionsort (ar: ARRAY [G]): ARRAY [G]
		do
			Result := sort (ar)
		end

end
