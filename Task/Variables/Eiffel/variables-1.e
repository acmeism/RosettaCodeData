class
	APPLICATION
inherit
	ARGUMENTS
create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			i: INTEGER
			s: STRING
		do
			i := 100
			s := "Some string"
			create a.make_empty
		end

feature {NONE} -- Class Features

a: ARRAY[INTEGER]
