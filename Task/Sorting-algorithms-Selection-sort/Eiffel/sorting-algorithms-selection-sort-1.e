class
	SELECTION_SORT[G -> COMPARABLE]



feature {NONE}
index_of_min(ar: ARRAY [G]; lower: INTEGER):INTEGER
		--find index of smallest element in array ar in the range of lower and the max index.
        require
        	lower_positiv : lower >=1
        	lower_in_range: lower <= ar.count
        	ar_not_void: ar/= Void
        local
                i, index: INTEGER
                min: G
        do
                from
                        i:=lower
                        min := ar.item (i)
                        index := i
                until
                        i+1 > ar.count
                loop
                        if  ar.item(i+1) < min then
                                min := ar.item(i+1)
                                index := i+1
                        end
                        i := i + 1
                end
                Result := index
		ensure
			result_is_set: Result /= Void
        end



sort (ar: ARRAY [G]):ARRAY[G]
                -- sort array ar with selectionsort
		require
			ar_not_void: ar/=VOID
		local
			min_index: INTEGER
			ith: G
        do
			across ar as ic loop
				min_index := index_of_min(ar,ic.cursor_index)
	       		ith:=ar[ic.cursor_index]
	       		ar[ic.cursor_index]:= ar[min_index]
	       		ar[min_index]:=ith
	       	end
	       	Result:= ar
		ensure
			Result_is_set: Result /= Void
        end


feature
selectionsort(ar: ARRAY[G]):ARRAY[G]
		do
			Result:= sort(ar)
		end
end
