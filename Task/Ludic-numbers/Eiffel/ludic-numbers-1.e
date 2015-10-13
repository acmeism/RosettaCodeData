class
	LUDIC_NUMBERS

create
	make

feature

	make (n: INTEGER)
			-- Initialized arrays for find_ludic_numbers.
		require
			n_positive: n > 0
		local
			i: INTEGER
		do
			create initial.make_filled (0, 1, n - 1)
			create ludic_numbers.make_filled (1, 1, 1)
			from
				i := 2
			until
				i > n
			loop
				initial.put (i, i - 1)
				i := i + 1
			end
			find_ludic_numbers
		end

	ludic_numbers: ARRAY [INTEGER]

feature {NONE}

	initial: ARRAY [INTEGER]

	find_ludic_numbers
			-- Ludic numbers in array ludic_numbers.
		local
			count: INTEGER
			new_array: ARRAY [INTEGER]
			last: INTEGER
		do
			create new_array.make_from_array (initial)
			last := initial.count
			from
				count := 1
			until
				count > last
			loop
				if ludic_numbers [ludic_numbers.count] /= new_array [1] then
					ludic_numbers.force (new_array [1], count + 1)
				end
				new_array := delete_i_elements (new_array)
				count := count + 1
			end
		end

	delete_i_elements (ar: ARRAY [INTEGER]): ARRAY [INTEGER]
			--- Array with all multiples of 'ar[1]' deleted.
		require
			ar_not_empty: ar.count > 0
		local
			s_array: ARRAY [INTEGER]
			i, k: INTEGER
			length: INTEGER
		do
			create s_array.make_empty
			length := ar.count
			from
				i := 0
				k := 1
			until
				i = length
			loop
				if (i) \\ (ar [1]) /= 0 then
					s_array.force (ar [i + 1], k)
					k := k + 1
				end
				i := i + 1
			end
			if s_array.count = 0 then
				Result := ar
			else
				Result := s_array
			end
		ensure
			not_empty: not Result.is_empty
		end

end
