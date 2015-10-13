class
	RADIX_SORT

feature

	radix_sort (ar: ARRAY [INTEGER])
			-- Array 'ar' sorted in ascending order.
		require
			ar_not_void: ar /= Void
			not_negative: across ar as a all a.item >= 0 end
		local
			bucket_1, bucket_0: LINKED_LIST [INTEGER]
			j, k, dig: INTEGER
		do
			create bucket_0.make
			create bucket_1.make
			dig := digits (ar)
			across
				0 |..| dig as c
			loop
				across
					ar as r
				loop
					if r.item.bit_test (c.item) then
						bucket_1.extend (r.item)
					else
						bucket_0.extend (r.item)
					end
				end
				from
					j := 1
				until
					j > bucket_0.count
				loop
					ar [j] := bucket_0 [j]
					j := j + 1
				end
				from
					k := j
					j := 1
				until
					j > bucket_1.count
				loop
					ar [k] := bucket_1 [j]
					k := k + 1
					j := j + 1
				end
				bucket_0.wipe_out
				bucket_1.wipe_out
			end
		ensure
			is_sorted: is_sorted (ar)
		end

feature {NONE}

	digits (ar: ARRAY [INTEGER]): INTEGER
			-- Number of digits of the largest item in 'ar'.
		local
			max: INTEGER
			math: DOUBLE_MATH
		do
			create math
			across
				ar as a
			loop
				if a.item > max then
					max := a.item
				end
			end
			Result := math.log_2 (max).ceiling + 1
		end

	is_sorted (ar: ARRAY [INTEGER]): BOOLEAN
			--- Is 'ar' sorted in ascending order?
		local
			i: INTEGER
		do
			Result := True
			from
				i := ar.lower
			until
				i >= ar.upper
			loop
				if ar [i] > ar [i + 1] then
					Result := False
				end
				i := i + 1
			end
		end

end
