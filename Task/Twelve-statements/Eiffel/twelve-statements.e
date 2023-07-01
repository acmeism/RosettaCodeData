class
	APPLICATION

create
	make

feature

	make
			-- Possible solutions.
		do
			create s.make_filled (False, 1, 12)
			s [1] := True
			recurseAll (2)
			io.put_string (counter.out + " solution found. ")
		end

feature {NONE}

	s: ARRAY [BOOLEAN]

	check2: BOOLEAN
			-- Is statement 2 fulfilled?
		local
			count: INTEGER
		do
			across
				7 |..| 12 as c
			loop
				if s [c.item] then
					count := count + 1
				end
			end
			Result := s [2] = (count = 3)
		end

	check3: BOOLEAN
			-- Is statement 3 fulfilled?
		local
			count, i: INTEGER
		do
			from
				i := 2
			until
				i > 12
			loop
				if s [i] then
					count := count + 1
				end
				i := i + 2
			end
			Result := s [3] = (count = 2)
		end

	check4: BOOLEAN
			-- Is statement 4 fulfilled?
		do
			Result := s [4] = ((not s [5]) or (s [6] and s [7]))
		end

	check5: BOOLEAN
			-- Is statement 5 fulfilled?
		do
			Result := s [5] = ((not s [2]) and (not s [3]) and (not s [4]))
		end

	check6: BOOLEAN
			-- Is statement 6 fulfilled?
		local
			count, i: INTEGER
		do
			from
				i := 1
			until
				i > 11
			loop
				if s [i] then
					count := count + 1
				end
				i := i + 2
			end
			Result := s [6] = (count = 4)
		end

	check7: BOOLEAN
			-- Is statement 7 fulfilled?
		do
			Result := s [7] = ((s [2] or s [3]) and not (s [2] and s [3]))
		end

	check8: BOOLEAN
			-- Is statement 8 fulfilled?
		do
			Result := s [8] = (not s [7] or (s [5] and s [6]))
		end

	check9: BOOLEAN
			-- Is statement 9 fulfilled?
		local
			count: INTEGER
		do
			across
				1 |..| 6 as c
			loop
				if s [c.item] then
					count := count + 1
				end
			end
			Result := s [9] = (count = 3)
		end

	check10: BOOLEAN
			-- Is statement 10 fulfilled?
		do
			Result := s [10] = (s [11] and s [12])
		end

	check11: BOOLEAN
			-- Is statement 11 fulfilled?
		local
			count: INTEGER
		do
			across
				7 |..| 9 as c
			loop
				if s [c.item] then
					count := count + 1
				end
			end
			Result := s [11] = (count = 1)
		end

	check12: BOOLEAN
			-- Is statement 12 fulfilled?
		local
			count: INTEGER
		do
			across
				1 |..| 11 as c
			loop
				if s [c.item] then
					count := count + 1
				end
			end
			Result := (s [12] = (count = 4))
		end

	counter: INTEGER

	checkit
			-- Check if all statements are correctly solved.
		do
			if check2 and check3 and check4 and check5 and check6 and check7 and check8 and check9 and check10 and check11 and check12 then
				across
					1 |..| 12 as c
				loop
					if s [c.item] then
						io.put_string (c.item.out + "%T")
					end
				end
				io.new_line
				counter := counter + 1
			end
		end

	recurseAll (k: INTEGER)
			-- All possible True and False combinations to check for a solution.
		do
			if k = 13 then
				checkit
			else
				s [k] := False
				recurseAll (k + 1)
				s [k] := True
				recurseAll (k + 1)
			end
		end

end
