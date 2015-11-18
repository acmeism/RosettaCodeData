class
	APPLICATION
inherit
	ARGUMENTS
create
	make

feature {NONE} -- Initialization

	make
		local
			i, j: INTEGER_32
		do
			io.read_integer_32
			i := io.last_integer_32

			io.read_integer_32
			j := io.last_integer_32

			if i < j then
				print("first is less than second%N")
			end
			if i = j then
				print("first is equal to the second%N")
			end
			if i > j then
				print("first is greater than second%N")
			end
		end
end
