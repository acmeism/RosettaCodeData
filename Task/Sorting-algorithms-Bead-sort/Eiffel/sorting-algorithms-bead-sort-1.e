class
	BEAD_SORT

feature

	bead_sort (ar: ARRAY [INTEGER]): ARRAY [INTEGER]
			-- Sorted array in descending order.
		require
			only_positive_integers: across ar as a all a.item > 0 end
		local
			max, count, i, j, k: INTEGER
		do
			max := max_item (ar)
			create Result.make_filled (0, 1, ar.count)
			from
				i := 1
			until
				i > max
			loop
				count := 0
				from
					k := 1
				until
					k > ar.count
				loop
					if ar.item (k) >= i then
						count := count + 1
					end
					k := k + 1
				end
				from
					j := 1
				until
					j > count
				loop
					Result [j] := i
					j := j + 1
				end
				i := i + 1
			end
		ensure
			array_is_sorted: is_sorted (Result)
		end

feature {NONE}

	max_item (ar: ARRAY [INTEGER]): INTEGER
			-- Max item of 'ar'.
		require
			ar_not_void: ar /= Void
		do
			across
				ar as a
			loop
				if a.item > Result then
					Result := a.item
				end
			end
		ensure
			Result_is_max: across ar as a all a.item <= Result end
		end

	is_sorted (ar: ARRAY [INTEGER]): BOOLEAN
			--- Is 'ar' sorted in descending order?
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
				if ar [i] < ar [i + 1] then
					Result := False
				end
				i := i + 1
			end
		end

end
