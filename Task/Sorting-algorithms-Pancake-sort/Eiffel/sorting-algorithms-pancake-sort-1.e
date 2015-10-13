class
	PANCAKE_SORT [G -> COMPARABLE]

feature {NONE}

	arraymax (array: ARRAY [G]; upper: INTEGER): INTEGER
			--- Max item of 'array' between index 1 and 'upper'.
		require
			upper_index_positive: upper >= 0
			array_not_void: array /= Void
		local
			i: INTEGER
			cur_max: G
		do
			from
				i := 1
				cur_max := array.item (i)
				Result := i
			until
				i + 1 > upper
			loop
				if array.item (i + 1) > cur_max then
					cur_max := array.item (i + 1)
					Result := i + 1
				end
				i := i + 1
			end
		ensure
			Index_positive: Result > 0
		end

	reverse_array (ar: ARRAY [G]; upper: INTEGER): ARRAY [G]
			-- Array reversed from index one to upper.
		require
			upper_positive: upper > 0
			ar_not_void: ar /= Void
		local
			i, j: INTEGER
			new_array: ARRAY [G]
		do
			create Result.make_empty
			Result.deep_copy (ar)
			from
				i := 1
				j := upper
			until
				i > j
			loop
				Result [i] := ar [j]
				Result [j] := ar [i]
				i := i + 1
				j := j - 1
			end
		ensure
			same_length: ar.count = Result.count
		end

	sort (ar: ARRAY [G]): ARRAY [G]
			-- Sorted array in ascending order.
		local
			i: INTEGER
		do
			create Result.make_empty
			Result.deep_copy (ar)
			from
				i := ar.count
			until
				i = 1
			loop
				Result := reverse_array (reverse_array (Result, arraymax (Result, i)), i)
				i := i - 1
			end
		ensure
			same_length: ar.count = Result.count
			Result_sorted: is_sorted (Result)
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

	pancake_sort (ar: ARRAY [G]): ARRAY [G]
		do
			Result := sort (ar)
		end

end
