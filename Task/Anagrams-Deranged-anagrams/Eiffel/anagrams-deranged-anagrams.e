class
	ANAGRAMS_DERANGED

create
	make

feature

	make
			-- Longest deranged anagram.
		local
			deranged_anagrams: LINKED_LIST [STRING]
			count: INTEGER
		do
			read_wordlist
			across
				words as wo
			loop
				deranged_anagrams := check_list_for_deranged (wo.item)
				if not deranged_anagrams.is_empty and deranged_anagrams [1].count > count then
					count := deranged_anagrams [1].count
				end
				wo.item.wipe_out
				wo.item.append (deranged_anagrams)
			end
			across
				words as wo
			loop
				across
					wo.item as w
				loop
					if w.item.count = count then
						io.put_string (w.item + "%T")
						io.new_line
					end
				end
			end
		end

	original_list: STRING = "unixdict.txt"

feature {NONE}

	check_list_for_deranged (list: LINKED_LIST [STRING]): LINKED_LIST [STRING]
			-- Deranged anagrams in 'list'.
		do
			create Result.make
			across
				1 |..| list.count as i
			loop
				across
					(i.item + 1) |..| list.count as j
				loop
					if check_for_deranged (list [i.item], list [j.item]) then
						Result.extend (list [i.item])
						Result.extend (list [j.item])
					end
				end
			end
		end

	check_for_deranged (a, b: STRING): BOOLEAN
			-- Are 'a' and 'b' deranged anagrams?
		local
			n: INTEGER
		do
			across
				1 |..| a.count as i
			loop
				if a [i.item] = b [i.item] then
					n := n + 1
				end
			end
			Result := n = 0
		end

	read_wordlist
			-- Hashtable 'words' with alphabetically sorted Strings used as key.
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
			--Alphabetically sorted.
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
