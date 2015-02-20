class
	APPLICATION
inherit
	ARGUMENTS
create
    make
feature
	make
	do
		test:= <<2,5,66,-2, 0, 7>>
		io.put_string ("%Nunsorted:%N")
		across	test as ar loop io.put_string (ar.item.out + "%T") end
		create stoogesort
		stoogesort.stoogesort (test, 1, test.count)
		io.put_string ("%Nsorted:%N")
	        across test as ar loop io.put_string (ar.item.out + "%T") end
	end
	test: ARRAY[INTEGER]
	stoogesort: STOOGE_SORT
end
