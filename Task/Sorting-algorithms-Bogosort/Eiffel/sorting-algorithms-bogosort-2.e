class
	APPLICATION

inherit
	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	make
		do
			test:= <<3,2,5,7,1>>
			io.put_string ("Unsorted: ")
			across test as t loop io.put_string (t.item.out + " ") end
			create sorter
			test:= sorter.bogo_sort (test)
			io.put_string ("%NSorted: ")
			across test as t loop io.put_string (t.item.out + " ") end
		end
	test: ARRAY[INTEGER]
        sorter: BOGO_SORT
end
