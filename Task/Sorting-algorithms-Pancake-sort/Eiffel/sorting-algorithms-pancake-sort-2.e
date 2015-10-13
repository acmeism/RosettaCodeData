class
	APPLICATION

create
	make

feature

	make
		do
			test := <<1, 27, 32, 99, 1, -7, 3, 5>>
			create sorter
			io.put_string ("Unsorted: ")
			across
				test as ar
			loop
				io.put_string (ar.item.out + " ")
			end
			io.put_string ("%NSorted: ")
			test := sorter.pancake_sort(test)
			across
				test as ar
			loop
				io.put_string (ar.item.out + " ")
			end
		end

	test: ARRAY [INTEGER]

	sorter: PANCAKE_SORT[INTEGER]

end
