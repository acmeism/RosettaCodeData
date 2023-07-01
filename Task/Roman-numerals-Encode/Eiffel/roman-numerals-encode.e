class
	APPLICATION

create
	make

feature {NONE} -- Initialization

	make
		local
			numbers: ARRAY [INTEGER]
		do
			numbers := <<1990, 2008, 1666, 3159, 1977, 2010>>
				   -- "MCMXC", "MMVIII", "MDCLXVI", "MMMCLIX", "MCMLXXVII", "MMX"
			across numbers as n loop
				print (n.item.out + " in decimal Arabic numerals is " +
				       decimal_to_roman (n.item) + " in Roman numerals.%N")
			end
		end

feature -- Roman numerals

	decimal_to_roman (a_int: INTEGER): STRING
		-- Representation of integer `a_int' as Roman numeral
		require
			a_int > 0
		local
			dnums: ARRAY[INTEGER]
			rnums: ARRAY[STRING]

			dnum: INTEGER
			rnum: STRING

			i: INTEGER
		do
			dnums := <<1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1>>
			rnums := <<"M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I">>

			dnum := a_int
			rnum := ""

			from
				i := 1
			until
				i > dnums.count or dnum <= 0
			loop
				from
				until
					dnum < dnums[i]
				loop
					dnum := dnum - dnums[i]
					rnum := rnum + rnums[i]
				end
				i := i + 1
			end

			Result := rnum
		end
end
