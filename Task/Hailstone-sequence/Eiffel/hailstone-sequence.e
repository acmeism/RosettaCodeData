class
	APPLICATION

create
	make

feature

	make
		local
			test: LINKED_LIST [INTEGER]
			count, number, te: INTEGER
		do
			create test.make
			test := hailstone_sequence (27)
			io.put_string ("There are " + test.count.out + " elements in the sequence for the number 27.")
			io.put_string ("%NThe first 4 elements are: ")
			across
				1 |..| 4 as t
			loop
				io.put_string (test [t.item].out + "%T")
			end
			io.put_string ("%NThe last 4 elements are: ")
			across
				(test.count - 3) |..| test.count as t
			loop
				io.put_string (test [t.item].out + "%T")
			end
			across
				1 |..| 99999 as c
			loop
				test := hailstone_sequence (c.item)
				te := test.count
				if te > count then
					count := te
					number := c.item
				end
			end
			io.put_string ("%NThe longest sequence for numbers below 100000 is " + count.out + " for the number " + number.out + ".")
		end

	hailstone_sequence (n: INTEGER): LINKED_LIST [INTEGER]
			-- Members of the Hailstone Sequence starting from 'n'.
		require
			n_is_positive: n > 0
		local
			seq: INTEGER
		do
			create Result.make
			from
				seq := n
			until
				seq = 1
			loop
				Result.extend (seq)
				if seq \\ 2 = 0 then
					seq := seq // 2
				else
					seq := ((3 * seq) + 1)
				end
			end
			Result.extend (seq)
		ensure
			sequence_terminated: Result.last = 1
		end

end
