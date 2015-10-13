class
	ONE_OF_N_LINES

create
	make

feature {NONE}

	r: RANDOM

feature

	make
		do
			create r.make
		end

	one_of_n_lines (n: INTEGER): INTEGER
                        -- A integer between 1 and 'n', denoting a line.
		require
			n_is_positive: n > 0
		local
			p: REAL_64
		do
			across
				1 |..| n as c
			loop
				p := r.double_item
				if p < (1 / c.item) then
					Result := c.item
				end
				r.forth
			end
		ensure
			Result_in_file: Result <= n
			Result_is_positive: Result > 0
		end

end
