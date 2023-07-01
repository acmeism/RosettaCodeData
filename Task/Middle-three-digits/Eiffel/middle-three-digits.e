class
	APPLICATION

create
	make

feature

	make
			-- Test of middle_three_digits.
		local
			test_1, test_2: ARRAY [INTEGER]
		do
			test_1 := <<123, 12345, 1234567, 987654321, 10001, -10001, -123, -100, 100, -12345>>
			test_2 := <<1, 2, -1, -10, 2002, -2002, 0>>
			across
				test_1 as t
			loop
				io.put_string ("The middle three digits of " + t.item.out + " are: %T ")
				io.put_string (middle_three_digits (t.item) + "%N")
			end
			across
				test_2 as t
			loop
				io.put_string ("The middle three digits of " + t.item.out + " are: %T")
				io.put_string (middle_three_digits (t.item) + "%N")
			end
		end

	middle_three_digits (n: INTEGER): STRING
			-- The middle three digits of 'n'.
		local
			k, i: INTEGER
			in: STRING
		do
			create in.make_empty
			in := n.out
			if n < 0 then
				in.prune ('-')
			end
			create Result.make_empty
			if in.count < 3 then
				io.put_string (" Not enough digits. ")
			elseif in.count \\ 2 = 0 then
				io.put_string (" Even number of digits. ")
			else
				i := (in.count - 3) // 2
				from
					k := i + 1
				until
					k > i + 3
				loop
					Result.extend (in.at (k))
					k := k + 1
				end
			end
		ensure
			length_is_three: Result.count = 3 or Result.count = 0
		end

end
