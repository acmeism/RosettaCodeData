class
	APPLICATION

create
	make

feature

	make
		do
			test := <<7, 99, -7, 1, 0, 25, -10>>
			io.put_string ("unsorted:%N")
			across
				test as ar
			loop
				io.put_string (ar.item.out + "%T")
			end
			io.new_line
			io.put_string ("sorted:%N")
			create gnome
			test := gnome.sort (test)
			across
				test as ar
			loop
				io.put_string (ar.item.out + "%T")
			end
		end

	test: ARRAY [INTEGER]

	gnome: GNOME_SORT [INTEGER]

end
