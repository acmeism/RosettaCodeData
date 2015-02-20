class
	APPLICATION
inherit
	ARGUMENTS
create
    make
feature
    make
	do
            test:= <<1, 5, 99, 2, 95, 7, 7>>
            create beadsort
            io.put_string ("unsorted:"+"%N")
            across test as ar loop io.put_string(ar.item.out + "%T")  end
	    io.put_string ("%N"+"sorted:"+"%N")
            test:= beadsort.bead_sort (test)
            across test as ar  loop io.put_string(ar.item.out + "%T")  end
        end
    beadsort: BEAD_SORT
    test: ARRAY[INTEGER]
end
