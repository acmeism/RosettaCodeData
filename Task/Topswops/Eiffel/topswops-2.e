class
	APPLICATION

create
	make

feature

	make
		do
			create topswop.make (10)
			across
				topswop.solution as t
			loop
				io.put_string (t.item.out + "%N")
			end
		end

	topswop: TOPSWOPS

end
