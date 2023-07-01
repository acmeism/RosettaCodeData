class
	APPLICATION

create
	make

feature

	make
		do
			create comb.make (5, 3)
			across
				comb.sol as ar
			loop
				io.put_string (ar.item.out + "%T")
			end
		end

	comb: COMBINATIONS

end
