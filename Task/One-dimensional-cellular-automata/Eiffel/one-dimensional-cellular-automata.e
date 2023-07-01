class
	APPLICATION

create
	make

feature

	make
			-- First 10 states of the cellular automata.
		local
			r: RANDOM
			automata: STRING
		do
			create r.make
			create automata.make_empty
			across
				1 |..| 10 as c
			loop
				if r.double_item < 0.5 then
					automata.append ("0")
				else
					automata.append ("1")
				end
				r.forth
			end
			across
				1 |..| 10 as c
			loop
				io.put_string (automata + "%N")
				automata := update (automata)
			end
		end

	update (s: STRING): STRING
			-- Next state of the cellular automata 's'.
		require
			enough_states: s.count > 1
		local
			i: INTEGER
		do
			create Result.make_empty
				-- Dealing with the left border.
			if s [1] = '1' and s [2] = '1' then
				Result.append ("1")
			else
				Result.append ("0")
			end
				-- Dealing with the middle cells.
			from
				i := 2
			until
				i = s.count
			loop
				if (s [i] = '0' and (s [i - 1] = '0' or (s [i - 1] = '1' and s [i + 1] = '0'))) or ((s [i] = '1') and ((s [i - 1] = '1' and s [i + 1] = '1') or (s [i - 1] = '0' and s [i + 1] = '0'))) then
					Result.append ("0")
				else
					Result.append ("1")
				end
				i := i + 1
			end
				-- Dealing with the right border.
			if s [s.count] = '1' and s [s.count - 1] = '1' then
				Result.append ("1")
			else
				Result.append ("0")
			end
		ensure
			has_same_length: s.count = Result.count
		end

end
