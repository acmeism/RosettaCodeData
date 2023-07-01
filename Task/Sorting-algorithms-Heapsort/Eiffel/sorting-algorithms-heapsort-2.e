class
	APPLICATION

create
	make

feature

	make
		local
			test: ARRAY [INTEGER]
		do
			create test.make_empty
			test := <<5, 91, 13, 99,7, 35>>
			io.put_string ("Unsorted: ")
			across
				test as t
			loop
				io.put_string (t.item.out + " ")
			end
			io.new_line
			create heap_sort
			heap_sort.sort_array (test)
			io.put_string ("Sorted: ")
			across
				test as t
			loop
				io.put_string (t.item.out + " ")
			end
		end

	heap_sort: HEAPSORT

end
