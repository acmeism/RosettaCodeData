feature
	some_procedure(int: INTEGER; char: CHARACTER)
		local
			r: REAL
			i: INTEGER
		do
			-- r, i and s have scope here
			-- as well as int and char
			-- some_procedure and some_function additionally have scope here			
		end

	s: STRING

	some_function(int: INTEGER): INTEGER
		do
			-- s and Result have scope here
			-- as well as int (int here differs from the int of some_procedure)
			-- some_procedure and some_function additionally have scope here
		end

	-- s, some_procedure and some_function have scope here
