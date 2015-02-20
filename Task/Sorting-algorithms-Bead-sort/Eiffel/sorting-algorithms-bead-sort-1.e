class
	BEAD_SORT
feature
	bead_sort(ar: ARRAY[INTEGER]): ARRAY[INTEGER]
		local
			max, count, i, j, k: INTEGER
			sorted: ARRAY[INTEGER]
		do
			max:= max_item(ar)
			create sorted.make_filled(0,1, ar.count)
			from
				i:= 1
			until
				i> max
			loop
				count:= 0
				from
					k:= 1
				until
					k> ar.count
				loop
					if ar.item (k) >= i then
						count:= count+1
					end
					k:= k+1
				end
				from
					j:= 1
				until
					j>count
				loop
					sorted[j]:= i
					j:= j+1
				end
				i:= i+1
			end
 			RESULT:= sorted
 		end

feature{NONE}
	max_item(ar: ARRAY [INTEGER]):INTEGER
                require
        	        ar_not_void: ar/= Void
                local
                        i, max: INTEGER
                do
                        from
                                i:=1
                        until
                                i > ar.count
                        loop
                                if  ar.item(i) > max then
                                        max := ar.item(i)
                                end
                                i := i + 1
                        end
                        Result := max
		ensure
			result_is_set: Result /= Void
                end
end
