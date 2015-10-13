class
	APPLICATION

create
	make

feature

	make
			-- Simulates one_of_n_lines a 1000000 times.
		local
			t: INTEGER
			simulator: ARRAY [INTEGER]
		do
			create simulator.make_filled (0, 1, 10)
			create one.make
			across
				1 |..| 1000000 as c
			loop
				t := one.one_of_n_lines (10)
				simulator [t] := simulator [t] + 1
			end
			across
				simulator as s
			loop
				io.put_integer (s.item)
				io.new_line
			end
		end

	one: ONE_OF_N_LINES

end
