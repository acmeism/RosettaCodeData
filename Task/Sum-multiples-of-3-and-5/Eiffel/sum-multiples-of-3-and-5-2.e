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
			create sum
			io.put_integer(sum.sum_multiples (1000))
		end
	sum: SUM_MULTIPLES_OF_THREE_AND_FIVE
end
