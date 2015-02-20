class
	APPLICATION

inherit
	ARGUMENTS

create
    make

feature
    make
	do
		test:= <<7, 99, -7, 1, 0, 25, -10>>
		create gnome
                test:= gnome.sort (test)
		across test as ar loop io.put_string( ar.item.out + "%T") end
	end

	test: ARRAY[INTEGER]
	gnome: GNOME_SORT[INTEGER]
end
