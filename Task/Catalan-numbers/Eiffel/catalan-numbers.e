class
	APPLICATION

create
	make

feature {NONE}

	make
		do
			across
				0 |..| 14 as c
			loop
				io.put_double (catalan_numbers (c.item))
				io.new_line
			end
		end

	nth_catalan_number (n: INTEGER): DOUBLE
			--'n'th number in the sequence of Catalan numbers.
		require
			n_not_negative: n >= 0
		local
			s, t: DOUBLE
		do
			if n = 0 then
				Result := 1.0
			else
				t := 4 * n.to_double - 2
				s := n.to_double + 1
				Result := t / s * catalan_numbers (n - 1)
			end
		end

end
