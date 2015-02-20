class
	APPLICATION

create
	make

feature {NONE} -- Initialization

	make
			-- Read from the file and print frequencies.
		local
			file: PLAIN_TEXT_FILE
		do
			create file.make_open_read("input.txt")
			file.read_stream(file.count)
			file.close
			across get_frequencies(file.last_string) as f loop
				print(f.key.out + ": " + f.item.out + "%N")
			end
		end

feature -- Access

	get_frequencies (s: STRING): HASH_TABLE[INTEGER, CHARACTER]
			-- Hash table of counts for alphabetic characters in `s'.
		local
			char: CHARACTER
		do
			create Result.make(0)
			across s.area as st loop
				char := st.item
				if char.is_alpha then
					if Result.has(char) then
						Result.force(Result.at(char) + 1, char)
					else
						Result.put (1, char)
					end
				end
			end
		end
end
