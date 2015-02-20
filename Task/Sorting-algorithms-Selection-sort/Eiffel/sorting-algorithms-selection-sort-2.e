class
	APPLICATION
inherit
	ARGUMENTS
create
    make

feature
    make

        do    	
       	test := <<1, 27, 32, 99, 1, -7, 3, 5, 7>>
        io.put_string ("Unsorted: ")
    	across test as ic  loop io.put_string (ic.item.out + " ") end
    	create selection
    	io.put_string ("%NSorted: ")
        test:= selectionsort.selectionsort(test)
    	across test as ar  loop io.put_string (ar.item.out + " ") end
        end

	test: ARRAY[INTEGER]
	selection: SELECTION_SORT[INTEGER]
end
