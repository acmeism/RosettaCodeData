class
	APPLICATION

create
	make

feature

	make
		local
			test: ARRAY [INTEGER]
		do
			create rs
			create test.make_empty
			test := <<5, 4, 999, 5, 70, 0, 1000, 55, 1, 2, 3>>
			io.put_string ("Unsorted:%N")
			across
				test as t
			loop
				io.put_string (t.item.out + " ")
			end
			rs.radix_sort (test)
			io.put_string ("%NSorted:%N")
			across
				test as t
			loop
				io.put_string (t.item.out + " ")
			end
		end

	rs: RADIX_SORT

end
