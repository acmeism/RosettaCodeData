class
	APPLICATION

create
	make

feature {NONE} -- Initialization

	make
		do
			test := <<1, 2>>
			io.put_string ("Initial: ")
			across
				test as t
			loop
				io.put_string (t.item.out + " ")
			end
			test := shuffle (test)
			io.new_line
			io.put_string ("Shuffled: ")
			across
				test as t
			loop
				io.put_string (t.item.out + " ")
			end
		end

	test: ARRAY [INTEGER]

	shuffle (ar: ARRAY [INTEGER]): ARRAY [INTEGER]
			-- Array containing the same elements as 'ar' in a shuffled order.
		require
			more_than_one_element: ar.count > 1
		local
			count, j, ith: INTEGER
			random: V_RANDOM
		do
			create random
			create Result.make_empty
			Result.deep_copy (ar)
			count := ar.count
			across
				1 |..| count as c
			loop
				j := random.bounded_item (c.item, count)
				ith := Result [c.item]
				Result [c.item] := Result [j]
				Result [j] := ith
				random.forth
			end
		ensure
			same_elements: across ar as a all Result.has (a.item) end
		end

end
