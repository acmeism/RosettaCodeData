class
	APPLICATION

create
	make

feature

	make
			-- Max Licences used.
		local
			count: INTEGER
			max_count: INTEGER
			date: STRING
		do
			read_list
			create date.make_empty
			across
				data as d
			loop
				if d.item.has_substring ("OUT") then
					count := count + 1
					if count > max_count then
						max_count := count
						date := d.item
					end
				elseif d.item.has_substring ("IN") then
					count := count - 1
				end
			end
			io.put_string ("Max Licences OUT: " + max_count.out)
			io.new_line
			io.put_string ("Date: " + date.substring (15, 33))
		end

	original_list: STRING = "mlijobs.txt"

feature {NONE}

	read_list
			-- Data read into 'data.
		local
			l_file: PLAIN_TEXT_FILE
		do
			create l_file.make_open_read_write (original_list)
			l_file.read_stream (l_file.count)
			data := l_file.last_string.split ('%N')
			l_file.close
		end

	data: LIST [STRING]

end
