class
	RANGE

create
	make

feature
	make
		local
			extended_range: STRING
		do
			extended_range := "0,  1,  2,  4,  6,  7,  8, 11, 12, 14, " +
				"15, 16, 17, 18, 19, 20, 21, 22, 23, 24, " +
				"25, 27, 28, 29, 30, 31, 32, 33, 35, 36, " +
                		"37, 38, 39"
			print("Extended range: " + extended_range + "%N")
			print("Extracted range: " + extracted_range(extended_range) + "%N%N")
		end

feature
	extracted_range(sequence: STRING): STRING
		local
			elements: LIST[STRING]
			first, curr: STRING
			subrange_size, index: INTEGER
		do
			sequence.replace_substring_all (", ", ",")
			elements := sequence.split (',')
			from
				index := 2
				first := elements.at (1)
				subrange_size := 0
				Result := ""
			until
				index > elements.count
			loop
				curr := elements.at (index)
				if curr.to_integer - first.to_integer - subrange_size = 1
				then
					subrange_size := subrange_size + 1
				else
					Result.append(first)
					if (subrange_size <= 1)
					then
						Result.append (", ")
					else
						Result.append (" - ")
					end
					if (subrange_size >= 1)
					then
						Result.append ((first.to_integer + subrange_size).out)
						Result.append (", ")
					end

					first := curr
					subrange_size := 0
				end
				index := index + 1
			end
			Result.append(first)
			if (subrange_size <= 1)
			then
				Result.append (", ")
			else
				Result.append (" - ")
			end
			if (subrange_size >= 1)
			then
				Result.append ((first.to_integer + subrange_size).out)
			end
		end
end
