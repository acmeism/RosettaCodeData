class
	GNOME_SORT

feature
	sort(ar: ARRAY[INTEGER]): ARRAY[INTEGER]
		-- sort array ar with gnome sort
	require
		array_not_void: ar/= VOID
	local
		i,j, ith: INTEGER
	do
		from
			i:= 2 		
			j:= 3
		until
			i>ar.count
		loop
			if	ar[i-1] <= ar[i] then
				i:= j
				j:= j+1
			else
				ith := ar[i-1]
				ar[i-1] := ar[i]
				ar[i] := ith
				i:= i-1
				if i=1 then
					i:=j
					j:= j+1
				end
			end
		end
		Result := ar
		ensure
			same_length: ar.count = Result.count
			same_items: Result.same_items (ar)
	end

end
