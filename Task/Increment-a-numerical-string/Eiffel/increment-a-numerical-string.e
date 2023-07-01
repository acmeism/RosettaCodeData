class
	APPLICATION

create
	make

feature {NONE}

	make
		do
			io.put_string (increment_numerical_string ("7"))
			io.new_line
			io.put_string (increment_numerical_string ("99"))
		end

	increment_numerical_string (s: STRING): STRING
			-- String 's' incremented by one.
		do
			Result := s.to_integer.plus (1).out
		end

end
