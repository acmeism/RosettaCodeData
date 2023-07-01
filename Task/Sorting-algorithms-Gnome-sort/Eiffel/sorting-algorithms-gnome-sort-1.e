class
	GNOME_SORT [G -> COMPARABLE]

feature

	sort (ar: ARRAY [G]): ARRAY [G]
			-- Sorted array in ascending order.
		require
			array_not_void: ar /= Void
		local
			i, j: INTEGER
			ith: G
		do
			create Result.make_empty
			Result.deep_copy (ar)
			from
				i := 2
				j := 3
			until
				i > Result.count
			loop
				if Result [i - 1] <= Result [i] then
					i := j
					j := j + 1
				else
					ith := Result [i - 1]
					Result [i - 1] := Result [i]
					Result [i] := ith
					i := i - 1
					if i = 1 then
						i := j
						j := j + 1
					end
				end
			end
		ensure
			Same_length: ar.count = Result.count
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
