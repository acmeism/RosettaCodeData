class
	COUNT_IN_FACTORS

feature

	display_factor (p: INTEGER)
			-- Factors of all integers up to 'p'.
		require
			p_positive: p > 0
		local
			factors: ARRAY [INTEGER]
		do
			across
				1 |..| p as c
			loop
				io.new_line
				io.put_string (c.item.out + "%T")
				factors := factor (c.item)
				across
					factors as f
				loop
					io.put_integer (f.item)
					if f.is_last = False then
						io.put_string (" x ")
					end
				end
			end
		end


        factor (p: INTEGER): ARRAY [INTEGER]
			-- Prime decomposition of 'p'.
		require
			p_positive: p > 0
		local
			div, i, next, rest: INTEGER
		do
			create Result.make_empty
			if p = 1 then
				Result.force (1, 1)
			end
			div := 2
			next := 3
			rest := p
			from
				i := 1
			until
				rest = 1
			loop
				from
				until
					rest \\ div /= 0
				loop
					Result.force (div, i)
					rest := (rest / div).floor
					i := i + 1
				end
				div := next
				next := next + 2
			end
		ensure
			is_divisor: across Result as r all p \\ r.item = 0 end
		end
end
