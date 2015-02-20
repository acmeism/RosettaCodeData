class
	NUMBER_REVERSAL_GAME
feature

	play_game
		local
			count: INTEGER
		do
			initialize_game
			io.put_string ("Let's play the number reversal game.%N")
			across numbers as ar loop io.put_string (ar.item.out + "%T")  end
			from

			until
				is_sorted(numbers,1, numbers.count)
			loop
				io.put_string ("%NHow many numbers should be reversed?%N")
				io.read_integer
			    reverse_array(io.last_integer)
			    across numbers as ar loop io.put_string (ar.item.out + "%T")  end
			    count:= count+1
			end
			io.put_string ("%NYou needed "+ count.out + " reversals.")
		end

feature {NONE}
	initialize_game
		local
			random: V_RANDOM
			item,i: INTEGER
		do
			create random
			create numbers.make_empty
			from
				i:= 1
			until
				numbers.count = 9
			loop

				item :=random.bounded_item (1, 9)
				if numbers.has (item)= FALSE then
					numbers.force(item, i)
					i:= i+1
				end
				random.forth
			end
		end

	numbers: ARRAY[INTEGER]

	reverse_array(upper:INTEGER)
    	require
    		upper_positive: upper >0
    		ar_not_void: numbers /= void
    	local
    		i,j:INTEGER
    		new_array: ARRAY[INTEGER]
    	do
    		create new_array.make_empty
			new_array.copy (numbers)
			from
				i:= 1
				j:=upper
			until
				i>j
			loop
				new_array[i]:=numbers[j]
				new_array[j]:=numbers[i]
				i:=i+1
				j:=j-1
			end
			numbers := new_array
    	end

    is_sorted(ar: ARRAY[INTEGER];l, r: INTEGER): BOOLEAN
		require
			ar_not_empty: ar.is_empty= FALSE
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
