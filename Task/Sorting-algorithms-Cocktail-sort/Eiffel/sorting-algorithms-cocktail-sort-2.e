class
	APPLICATION

create
	make

feature

	make
		do
			test := <<5, 1, 99, 3, 2>>
			io.put_string ("unsorted%N")
			across
				test as t
			loop
				io.put_string (t.item.out + "%T")
			end
			io.new_line
			io.put_string ("sorted%N")
			create cs
			test := cs.cocktail_sort (test)
			across
				test as ar
			loop
				io.put_string (ar.item.out + "%T")
			end
		end

	cs: COCKTAIL_SORT [INTEGER]

	test: ARRAY [INTEGER]

end
