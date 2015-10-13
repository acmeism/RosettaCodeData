class
	COCKTAIL_SORT [G -> COMPARABLE]

feature

	cocktail_sort (ar: ARRAY [G]): ARRAY [G]
			-- Array sorted in ascending order.
		require
			ar_not_empty: ar.count >= 1
		local
			not_swapped: BOOLEAN
			sol: ARRAY [G]
			i, j: INTEGER
			t: G
		do
			create Result.make_empty
			Result.deep_copy (ar)
			from
			until
				not_swapped = True
			loop
				not_swapped := True
				from
					i := Result.lower
				until
					i = Result.upper - 1
				loop
					if Result [i] > Result [i + 1] then
						Result := swap (Result, i)
						not_swapped := False
					end
					i := i + 1
				end
				from
					j := Result.upper - 1
				until
					j = Result.lower
				loop
					if Result [j] > Result [j + 1] then
						Result := swap (Result, j)
						not_swapped := False
					end
					j := j - 1
				end
			end
		ensure
			ar_is_sorted: is_sorted (Result)
		end

feature{NONE}

	swap (ar: ARRAY [G]; i: INTEGER): ARRAY [G]
			-- Array with elements i and i+1 swapped.
		require
			ar_not_void: ar /= Void
			i_is_in_bounds: ar.valid_index (i)
		local
			t: G
		do
			create Result.make_empty
			Result.deep_copy (ar)
			t := Result [i]
			Result [i] := Result [i + 1]
			Result [i + 1] := t
		ensure
			swapped_right: Result [i + 1] = ar [i]
			swapped_left: Result [i] = ar [i + 1]
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

end
