class
	APPLICATION

create
	make

feature

	make
		do
			test := <<1, 5, 99, 2, 95, 7, -7>>
			io.put_string ("unsorted" + "%N")
			across
				test as ar
			loop
				io.put_string (ar.item.out + "%T")
			end
			io.put_string ("%N" + "sorted:" + "%N")
			create combsort
			test := combsort.combsort (test)
			across
				test as ar
			loop
				io.put_string (ar.item.out + "%T")
			end
		end

	combsort: COMB_SORT [INTEGER]

	test: ARRAY [INTEGER]

end
