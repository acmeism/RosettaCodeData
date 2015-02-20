class
	MERGE_SORT [G -> COMPARABLE]
create
	sort
feature
	sort(ar: ARRAY[G])
	-- sort array ar with mergesort and save it in sorted_array
           require
           	ar_not_empty: ar.is_empty= FALSE
           do
			create sorted_array.make_empty
			mergesort(ar, 1, ar.count)
			sorted_array:= ar
		   ensure
		   	sorted_array_not_empty: sorted_array.is_empty = FALSE
		   	sorted: is_sorted(sorted_array, 1, sorted_array.count)= TRUE
	       end
	sorted_array: ARRAY[G]
feature {NONE}
	mergesort(ar:ARRAY[G]; l,r:INTEGER)
		local
			m: INTEGER
		do
			if l<r then
				m := (l+r)//2
				mergesort(ar,l, m)
				mergesort(ar,m+1,r)
				merge(ar,l,m,r)
			end
		end

	merge(ar:ARRAY[G]; l,m,r: INTEGER)
		require
			positive_index_l: l>=1
			positive_index_m: m>=1
			positive_index_r: r>=1
			ar_not_empty: ar.is_empty= FALSE
		local
			merged: ARRAY[G]
			h,i,j,k: INTEGER
		do
			i := l
			j := m+1
			k := l
			create merged.make_empty
			from
			until
				i > m or j > r
			loop
				if ar.item (i) <= ar.item (j) then
					merged.force(ar.item(i),k)
					i := i +1
				elseif ar.item (i) > ar.item (j) then
					merged.force(ar.item(j),k)
					j := j+1
				end
				k := k+1
			end
			if i > m then
				from
					h := j
				until
					h > r
				loop
					merged.force(ar.item(h),k+h-j)
					h := h+1
				end
			elseif j > m then
				from
					h := i
				until
					h > m
				loop
					merged.force(ar.item(h),k+h-i)
					h := h+1
				end
			end
			from
				h := l
			until
				h > r
			loop
				ar.item (h) := merged.item (h)
				h := h+1
			end
			ensure
				is_partially_sorted: is_sorted(ar, l,r)= TRUE
		end

	is_sorted(ar: ARRAY[G];l, r: INTEGER): BOOLEAN
                --- feature is not required for mergesort but is used for contracts
		require
			ar_not_empty: ar.is_empty= FALSE
			l_in_range: l >= 1
			r_in_range: r <= ar.count
		local
			smaller : BOOLEAN
			i: INTEGER
		do
			smaller:= TRUE
			from
				i:= l
			until
				i=r
			loop
				if ar[i]> ar[i+1]	then
					smaller:= FALSE
				end
				i:= i+1
			end
			if smaller = TRUE then
				RESULT := TRUE
			else
				RESULT:= FALSE
			end
		end
end
