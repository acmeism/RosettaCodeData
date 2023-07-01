class
	APPLICATION

create
	make

feature {NONE} -- Initialization

	make
		local
			numbers: ARRAY [STRING]
		do
			numbers := <<"MCMXC", "MMVIII", "MDCLXVI",
			           -- 1990     2008      1666
			              "MMMCLIX", "MCMLXXVII", "MMX">>
			           -- 3159       1977         2010
			across numbers as n loop
				print (n.item +
                                       " in Roman numerals is " +
				       roman_to_decimal (n.item).out +
                                       " in decimal Arabic numerals.")
				print ("%N")
			end
		end

feature -- Roman numerals

	roman_to_decimal (a_str: STRING): INTEGER
		-- Decimal representation of Roman numeral `a_str'
		require
			is_roman (a_str)
		local
			l_pos: INTEGER
			cur: INTEGER -- Value of the digit read in the current iteration
			prev: INTEGER -- Value of the digit read in the previous iteration
		do
			from
				l_pos := 0
				Result := 0
				prev := 1 + max_digit_value
			until
				l_pos = a_str.count
			loop
				l_pos := l_pos + 1
				cur := roman_digit_to_decimal (a_str.at (l_pos))
				if cur <= prev then
					-- Add nonincreasing digit
					Result := Result + cur
				else
					-- Subtract previous digit from increasing digit
					Result := Result - prev + (cur - prev)
				end
				prev := cur
			end
		ensure
			Result >= 0
		end

	is_roman (a_string: STRING): BOOLEAN
		-- Is `a_string' a valid sequence of Roman digits?
		do
			Result := across a_string as c all is_roman_digit (c.item) end
		end

feature {NONE} -- Implementation

	max_digit_value: INTEGER = 1000

	is_roman_digit (a_char: CHARACTER): BOOLEAN
		-- Is `a_char' a valid Roman digit?
		local
			l_char: CHARACTER
		do
			l_char := a_char.as_upper
			inspect l_char
				when 'I', 'V', 'X', 'L', 'C', 'D', 'M' then
					Result := True
				else
					Result := False
			end
		end

	roman_digit_to_decimal (a_char: CHARACTER): INTEGER
		-- Decimal representation of Roman digit `a_char'
		require
			is_roman_digit (a_char)
		local
			l_char: CHARACTER
		do
			l_char := a_char.as_upper
			inspect l_char
				when 'I' then
					Result := 1
				when 'V' then
					Result := 5
				when 'X' then
					Result := 10
				when 'L' then
					Result := 50
				when 'C' then
					Result := 100
				when 'D' then
					Result := 500
				when 'M' then
					Result := 1000
			end
		ensure
			Result > 0
		end

end
