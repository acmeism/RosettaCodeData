class
	APPLICATION

create
	make

feature

	make
		do
			test := <<2, 5, 66, -2, 0, 7>>
			io.put_string ("unsorted" + "%N")
			across
				test as ar
			loop
				io.put_string (ar.item.out + "%T")
			end
			io.put_string ("%N" + "sorted" + "%N")
			create merge.sort (test)
			across
				merge.sorted_array as ar
			loop
				io.put_string (ar.item.out + "%T")
			end
		end

	test: ARRAY [INTEGER]

	merge: MERGE_SORT [INTEGER]

end
