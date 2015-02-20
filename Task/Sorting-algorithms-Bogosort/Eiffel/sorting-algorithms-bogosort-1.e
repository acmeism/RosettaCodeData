class
	BOGO_SORT
feature
	bogo_sort(ar: ARRAY[INTEGER]): ARRAY[INTEGER]
	do
		from
		until
			is_sorted (ar) = TRUE
		loop
			Result:= shuffel(ar)
		end
	end
feature{NONE}
	is_sorted (ar:ARRAY[INTEGER]): BOOLEAN
		require
			not_void: ar /= Void
		local
			i: INTEGER
		do
			Result := True
			from
				i := 1+ 1
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

	shuffel(ar:ARRAY[INTEGER]): ARRAY[INTEGER]
	        require
		        not_void: ar/= Void
	        local
		        i,j:INTEGER
		        ith: INTEGER
		        random: V_RANDOM
	        do
	        	create random
		        from
			        i:=ar.count
		        until
			        i<2
		        loop
			        j:=random.bounded_item (1, i)
			        ith:= ar[i]
			        ar[i]:= ar[j]
			        ar[j]:= ith
			        random.forth
			        i:=i-1
		        end
		        Result:= ar
	        end
end
