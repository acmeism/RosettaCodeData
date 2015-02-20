class
	LUDIC_NUMBERS
create make
feature
	make(n: INTEGER)
	-- make an Initial Array filled with the numbers from 1 to n
	-- make an Array for ludic_numbers filled with an initial 1
	require
		n_positive: n>0
	local
		i: INTEGER
	do
		create initial.make_filled (0, 1, n-1)
		create ludic_numbers.make_filled(1,1,1)
		from i:= 2
		until i> n
		loop
			initial.put (i, i-1)
			i:= i+1
		end
		ludic
	end
	ludic_numbers: ARRAY[INTEGER]

feature{NONE}
	initial: ARRAY[INTEGER]

	ludic
	--- forces the first element (initial[1]) of the initial array into ludic_numbers
        --- before deleting it and all multiples of it
	local
		count: INTEGER
		new_array: ARRAY[INTEGER]
	do
		create new_array.make_from_array (initial)
		from
			count:= 1
		until
			count> initial.count
		loop
			if ludic_numbers[ludic_numbers.count]/= new_array[1] then
				ludic_numbers.force (new_array[1], count+1)
			end
			new_array:= delete_i_elements(new_array)
			count:= count+1
		end
	end

	delete_i_elements(ar: ARRAY[INTEGER]): ARRAY[INTEGER]
	--- delete all multiples of ar[1] from the array ar (Eiffel starts indexing at 1)
	require
		ar_not_empty: ar.count >0
	local
	        s_array: ARRAY[INTEGER]
	        i,k: INTEGER
	do
		create s_array.make_empty
		from
			i:= 1
			k:= 1
		until
			i>ar.count
		loop
			if (i-1)\\(ar[1])/=0 then
				s_array.force (ar[i], k)
				k:= k+1
			end
			i:= i+1
		end
		if s_array.count=0 then
			Result:= ar
		else
		Result:= s_array
		end
	ensure
		not_empty : Result.count>0
	end
end
