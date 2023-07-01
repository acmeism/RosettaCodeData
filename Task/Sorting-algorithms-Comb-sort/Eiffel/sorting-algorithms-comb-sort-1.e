class
	COMB_SORT [G -> COMPARABLE]

feature

	combsort (ar: ARRAY [G]): ARRAY [G]
			-- Sorted array in ascending order.
		require
			array_not_void: ar /= Void
		local
			gap, i: INTEGER
			swap: G
			swapped: BOOLEAN
			shrink: REAL_64
		do
			create Result.make_empty
			Result.deep_copy (ar)
			gap := Result.count
			from
			until
				gap = 1 and swapped = False
			loop
				from
					i := Result.lower
					swapped := False
				until
					i + gap > Result.count
				loop
					if Result [i] > Result [i + gap] then
						swap := Result [i]
						Result [i] := Result [i + gap]
						Result [i + gap] := swap
						swapped := True
					end
					i := i + 1
				end
				shrink := gap / 1.3
				gap := shrink.floor
				if gap < 1 then
					gap := 1
				end
			end
		ensure
			Result_is_set: Result /= Void
			Result_is_sorted: is_sorted (Result)
		end

feature {NONE}

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

end
