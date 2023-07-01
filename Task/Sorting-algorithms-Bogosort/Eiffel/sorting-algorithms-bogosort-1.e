class
	BOGO_SORT

feature

	bogo_sort (ar: ARRAY [INTEGER]): ARRAY [INTEGER]
			-- Sorted array in ascending order.
		do
			from
			until
				is_sorted (ar) = True
			loop
				Result := shuffel (ar)
			end
		end

feature {NONE}

	is_sorted (ar: ARRAY [INTEGER]): BOOLEAN
			-- Is 'ar' sorted in ascending order?
		require
			not_void: ar /= Void
		local
			i: INTEGER
		do
			Result := True
			from
				i := 1 + 1
			invariant
				i >= 1 + 1 and i <= ar.count + 1
			until
				i > ar.count
			loop
				Result := Result and ar [i - 1] <= ar [i]
				i := i + 1
			variant
				ar.count + 1 - i
			end
		end

	shuffle (ar: ARRAY [INTEGER]): ARRAY [INTEGER]
			-- Array containing the same elements as 'ar' in a shuffled order.
		require
			more_than_one_element: ar.count > 1
		local
			count, j, ith: INTEGER
			random: V_RANDOM
		do
			create random
			create Result.make_empty
			Result.deep_copy (ar)
			count := ar.count
			across
				1 |..| count as c
			loop
				j := random.bounded_item (c.item, count)
				ith := Result [c.item]
				Result [c.item] := Result [j]
				Result [j] := ith
				random.forth
			end
		ensure
			same_elements: across ar as a all Result.has (a.item) end
		end

end
