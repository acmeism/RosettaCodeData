class
	APPLICATION

create
	make

feature {NONE}

	make
			-- Plays Number Reversal Game.
		local
			count: INTEGER
		do
			initialize_game
			io.put_string ("Let's play the number reversal game.%N")
			across
				numbers as ar
			loop
				io.put_string (ar.item.out + "%T")
			end
			from
			until
				is_sorted (numbers, 1, numbers.count)
			loop
				io.put_string ("%NHow many numbers should be reversed?%N")
				io.read_integer
				reverse_array (io.last_integer)
				across
					numbers as ar
				loop
					io.put_string (ar.item.out + "%T")
				end
				count := count + 1
			end
			io.put_string ("%NYou needed " + count.out + " reversals.")
		end

feature {NONE}

	initialize_game
			-- Array with numbers from 1 to 9 in a random unsorted order.
		local
			random: V_RANDOM
			item, i: INTEGER
		do
			create random
			create numbers.make_empty
			from
				i := 1
			until
				numbers.count = 9 and not is_sorted (numbers, 1, numbers.count)
			loop
				item := random.bounded_item (1, 9)
				if not numbers.has (item) then
					numbers.force (item, i)
					i := i + 1
				end
				random.forth
			end
		end

	numbers: ARRAY [INTEGER]

	reverse_array (upper: INTEGER)
			-- Array numbers with first element up to nth element reversed.
		require
			upper_positive: upper > 0
			ar_not_void: numbers /= Void
		local
			i, j: INTEGER
			new_array: ARRAY [INTEGER]
		do
			create new_array.make_empty
			new_array.deep_copy (numbers)
			from
				i := 1
				j := upper
			until
				i > j
			loop
				new_array [i] := numbers [j]
				new_array [j] := numbers [i]
				i := i + 1
				j := j - 1
			end
			numbers := new_array
		end

	is_sorted (ar: ARRAY [INTEGER]; l, r: INTEGER): BOOLEAN
			-- Is Array 'ar' sorted in ascending order?
		require
			ar_not_empty: not ar.is_empty
		do
			Result := True
			across
				1 |..| (r - 1) as c
			loop
				if ar [c.item] > ar [c.item + 1] then
					Result := False
				end
			end
		end

end
