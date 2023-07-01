class
	COUNTING_SORT

feature

	sort (ar: ARRAY [INTEGER]; min, max: INTEGER): ARRAY [INTEGER]
			-- Sorted Array in ascending order.
		require
			ar_not_void: ar /= Void
			lowest_index_zero: ar.lower = 0
		local
			count: ARRAY [INTEGER]
			i, j, z: INTEGER
		do
			create Result.make_empty
			Result.deep_copy (ar)
			create count.make_filled (0, 0, max - min)
			from
				i := 0
			until
				i = Result.count
			loop
				count [Result [i] - min] := count [Result [i] - min] + 1
				i := i + 1
			end
			z := 0
			from
				i := min
			until
				i > max
			loop
				from
					j := 0
				until
					j = count [i - min]
				loop
					Result [z] := i
					z := z + 1
					j := j + 1
				end
				i := i + 1
			end
		ensure
			Result_is_sorted: is_sorted (Result)
		end

feature {NONE}

	is_sorted (ar: ARRAY [INTEGER]): BOOLEAN
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

end
