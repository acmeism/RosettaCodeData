class
	SEMORDNILAP

create
	make

feature

	make
			--Semordnilaps in 'solution'.
		local
			count, i, middle, upper, lower: INTEGER
			reverse: STRING
		do
			read_wordlist
			create solution.make_empty
			from
				i := 1
			until
				i > word_array.count
			loop
				word_array [i].mirror
				reverse := word_array [i]
				from
					lower := i + 1
					upper := word_array.count
				until
					lower >= upper
				loop
					middle := (upper - lower) // 2 + lower
					if reverse.same_string (word_array [middle]) then
						count := count + 1
						upper := 0
						lower := 1
						solution.force (word_array [i], count)
					elseif reverse.is_less (word_array [middle]) then
						upper := middle - 1
					else
						lower := middle + 1
					end
				end
				if lower < word_array.count and then reverse.same_string (word_array [lower]) then
					count := count + 1
					upper := 0
					lower := 1
					solution.force (word_array [i], count)
				end
				i := i + 1
			end
		end

	solution: ARRAY [STRING]

	original_list: STRING = "unixdict.txt"


feature {NONE}

	read_wordlist
			-- Preprocessed word_array for finding Semordnilaps.
		local
			l_file: PLAIN_TEXT_FILE
			wordlist: LIST [STRING]
		do
			create l_file.make_open_read_write (original_list)
			l_file.read_stream (l_file.count)
			wordlist := l_file.last_string.split ('%N')
			l_file.close
			create word_array.make_empty
			across
				1 |..| wordlist.count as i
			loop
				word_array.force (wordlist.at (i.item), i.item)
			end
		end

	word_array: ARRAY [STRING]

end
