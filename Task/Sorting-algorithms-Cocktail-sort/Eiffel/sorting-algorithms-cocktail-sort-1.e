class
	COCKTAIL_SORT[G -> COMPARABLE]
feature
cocktail_sort(ar: ARRAY[G]): ARRAY[G]
	require
		ar_not_empty: ar.count>=1
	local
		swapped, finished: BOOLEAN
		sol: ARRAY[G]
		i,j : INTEGER
		t: G
	do
		create sol.make_from_array (ar)
		from
		until finished= TRUE
		loop
		swapped := FALSE
		from
			i:= 1
		until
			i= ar.count-1
		loop
			if ar[i]> ar[i+1]		then
				t:= ar[i]
				ar[i]:= ar[i+1]
				ar[i+1]:= t
				swapped:= true
			end
			i:= i+1
		end

		from j:= ar.count-1
		until j= 1
		loop
		if ar[j]> ar[j+1] then
			t:= ar[j]
			ar[j]:= ar[j+1]
			ar[j+1]:= t
			swapped:= TRUE
		end
		j:= j-1
		end
		if swapped= FALSE then
			finished:= TRUE
			sol:= ar
		end
		end
		Result:= sol
	end
end
