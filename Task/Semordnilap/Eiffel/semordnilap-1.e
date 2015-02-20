note
	description: "Summary description for {SEMORDNILAP}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEMORDNILAP
create
	make

	feature
	make
		--read wordlist "unixdict.txt", search across wordlist with binary_search
		local
			count,i,j, middle, upper, lower: INTEGER
			reverse: STRING
		do
			read_wordlist
			create solution.make_empty
			from
				i:= 1
			until
				i> word_array.count
			loop
				word_array[i].mirror
				reverse:=word_array[i]
				from
					lower:= i+1
					upper:= word_array.count
				until
					lower>=upper
				loop

					middle:= (upper-lower)//2+lower
					if reverse.is_case_insensitive_equal (word_array[middle]) then
									count:= count+1
									upper:= 0
									lower:= 1
									solution.force (word_array[middle],count)
					elseif reverse.is_less (word_array[middle]) then
						upper:= middle-1
					else
						lower:= middle+1
					end
				end
				if lower < word_array.count and then reverse.is_case_insensitive_equal (word_array[lower]) then
									count:= count+1
									upper:= 0
									lower:= 1
									solution.force (word_array[middle],count)
				end
				i:= i+1
			end
		end

	solution: ARRAY[STRING]

feature {NONE}
	read_wordlist
		local
			l_file: PLAIN_TEXT_FILE
			wordlist: LIST[STRING]
			i: INTEGER
		do
			create l_file.make_open_read_write ("unixdict.txt")
			l_file.read_stream (l_file.count)
			wordlist:=l_file.last_string.split ('%N')
			create word_array.make_empty
			from
				i:= 1
			until
				i> wordlist.count
			loop
				word_array.force( wordlist.at (i),i)
				i:= i+1
			end
		end
	word_array: ARRAY[STRING]
end
