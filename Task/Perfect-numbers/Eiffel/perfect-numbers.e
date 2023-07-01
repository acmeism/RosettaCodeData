class
	APPLICATION

create
	make

feature

	make
		do
			io.put_string ("  6 is perfect...%T")
			io.put_boolean (is_perfect_number (6))
			io.new_line
			io.put_string (" 77 is perfect...%T")
			io.put_boolean (is_perfect_number (77))
			io.new_line
			io.put_string ("128 is perfect...%T")
			io.put_boolean (is_perfect_number (128))
			io.new_line
			io.put_string ("496 is perfect...%T")
			io.put_boolean (is_perfect_number (496))
		end

	is_perfect_number (n: INTEGER): BOOLEAN
			-- Is 'n' a perfect number?
		require
			n_positive: n > 0
		local
			sum: INTEGER
		do
			across
				1 |..| (n - 1) as c
			loop
				if n \\ c.item = 0 then
					sum := sum + c.item
				end
			end
			Result := sum = n
		end

end
