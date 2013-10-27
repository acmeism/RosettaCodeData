class
	APPLICATION

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			numbers: ARRAY [INTEGER]
			greatest: GREATEST_ELEMENT [INTEGER]
		do
			create greatest.make
			numbers := <<1, 2, 3, 4, 5, 6, 7, 8, 9>>
			print (greatest.greatest_element (numbers))
		end

end
