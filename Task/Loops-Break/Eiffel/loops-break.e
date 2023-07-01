example
		-- Eiffel example code
	local
		n: INTEGER
		r: RANDOMIZER
	do
		from
			create r
			n := r.random_integer_in_range (0 |..| 19)
		until
			n = 10
		loop
			n := r.random_integer_in_range (0 |..| 19)
		end
	end
