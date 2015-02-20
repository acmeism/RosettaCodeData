class
	COMB_SORT[G -> COMPARABLE]
feature
	combsort (ar: ARRAY[G]): ARRAY[G]
		require
			array_not_empty: ar.count >0
		local
			gap, i: INTEGER
			swap: G
			swapped: BOOLEAN
			shrink: REAL_64
		do
			gap:= ar.count
			from

			until
				gap= 1 and swapped = false
			loop
				from
					i:= 1
					swapped:= false
				until
					i+gap > ar.count
				loop
					if ar[i]> ar[i+gap] then
						swap:= ar[i]
						ar[i]:= ar[i+gap]
						ar[i+gap]:= swap
						swapped:= TRUE
					end
					i:= i+1
				end
				shrink:= gap/1.3
				gap:= shrink.floor
				if  gap <1 then
					gap:= 1
				end
			end
			RESULT:= ar
			ensure
				RESULT_is_set: Result /= VOID

		end
end
