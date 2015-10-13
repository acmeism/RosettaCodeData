class
	ANAGRAMS

create
	make

feature

	make
			-- Set of Anagrams, containing most words.
		local
			count: INTEGER
		do
			read_wordlist
			across
				words as wo
			loop
				if wo.item.count > count then
					count := wo.item.count
				end
			end
			across
				words as wo
			loop
				if wo.item.count = count then
					across
						wo.item as list
					loop
						io.put_string (list.item + "%T")
					end
					io.new_line
				end
			end
		end

	original_list: STRING = "unixdict.txt"

feature {NONE}

	read_wordlist
			-- Preprocessed wordlist for finding Anagrams.
		local
			l_file: PLAIN_TEXT_FILE
			sorted: STRING
			empty_list: LINKED_LIST [STRING]
		do
			create l_file.make_open_read_write (original_list)
			l_file.read_stream (l_file.count)
			wordlist := l_file.last_string.split ('%N')
			l_file.close
			create words.make (wordlist.count)
			across
				wordlist as w
			loop
				create empty_list.make
				sorted := sort_letters (w.item)
				words.put (empty_list, sorted)
				if attached words.at (sorted) as ana then
					ana.extend (w.item)
				end
			end
		end

	wordlist: LIST [STRING]

	sort_letters (word: STRING): STRING
			--Sorted in alphabetical order.
		local
			letters: SORTED_TWO_WAY_LIST [STRING]
		do
			create letters.make
			create Result.make_empty
			across
				1 |..| word.count as i
			loop
				letters.extend (word.at (i.item).out)
			end
			across
				letters as s
			loop
				Result.append (s.item)
			end
		end

	words: HASH_TABLE [LINKED_LIST [STRING], STRING]

end
