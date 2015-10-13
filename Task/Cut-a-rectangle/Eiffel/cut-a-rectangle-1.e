class
	APPLICATION

create
	make

feature {NONE} -- Initialization

	make
			-- Finds solution for cut a rectangle up to 10 x 10.
		local
			i, j, n: Integer
			r: GRID
		do
			n := 10
			from
				i := 1
			until
				i > n
			loop
				from
					j := 1
				until
					j > i
				loop
					if i.bit_and (1) /= 1 or j.bit_and (1) /= 1 then
						create r.make (i, j)
						r.print_solution
					end
					j := j + 1
				end
				i := i + 1
			end
		end

end
