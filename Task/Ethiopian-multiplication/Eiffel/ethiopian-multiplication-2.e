class
	APPLICATION
inherit
	ARGUMENTS
create
	make
feature {NONE} -- Initialization
	make
        	local
		do
			create mult
			io.put_integer ( mult.ethiopian_mult (17,34))
		end
	mult: ETHIOPIAN_MULTIPLICATION
end
