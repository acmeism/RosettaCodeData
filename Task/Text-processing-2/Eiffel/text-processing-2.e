class
	APPLICATION

create
	make

feature

	make
			-- Finds double date stamps and wrong formats.
		local
			found: INTEGER
			double: STRING
		do
			read_wordlist
			fill_hash_table
			across
				hash as h
			loop
				if h.key.has_substring ("_double") then
					io.put_string ("Double date stamp: %N")
					double := h.key
					double.remove_tail (7)
					io.put_string (double)
					io.new_line
				end
				if h.item.count /= 24 then
					io.put_string (h.key.out + " has the wrong format. %N")
					found := found + 1
				end
			end
			io.put_string (found.out + " records have not 24 readings.%N")
			good_records
		end

	good_records
			-- Number of records that have flag values > 0 for all readings.
		local
			count, total: INTEGER
			end_date: STRING
		do
			create end_date.make_empty
			across
				hash as h
			loop
				count := 0
				across
					h.item as d
				loop
					if d.item.flag > 0 then
						count := count + 1
					end
				end
				if count = 24 then
					total := total + 1
				end
			end
			io.put_string ("%NGood records: " + total.out + ". %N")
		end

	original_list: STRING = "readings.txt"

	read_wordlist
			--Preprocesses data in 'data'.
		local
			l_file: PLAIN_TEXT_FILE
		do
			create l_file.make_open_read_write (original_list)
			l_file.read_stream (l_file.count)
			data := l_file.last_string.split ('%N')
			l_file.close
		end

	data: LIST [STRING]

	fill_hash_table
			--Fills 'hash' using the date as key.
		local
			by_dates: LIST [STRING]
			date: STRING
			data_tup: TUPLE [val: REAL; flag: INTEGER]
			data_arr: ARRAY [TUPLE [val: REAL; flag: INTEGER]]
			i: INTEGER
		do
			create hash.make (data.count)
			across
				data as d
			loop
				if not d.item.is_empty then
					by_dates := d.item.split ('%T')
					date := by_dates [1]
					by_dates.prune (date)
					create data_tup
					create data_arr.make_empty
					from
						i := 1
					until
						i > by_dates.count - 1
					loop
						data_tup := [by_dates [i].to_real, by_dates [i + 1].to_integer]
						data_arr.force (data_tup, data_arr.count + 1)
						i := i + 2
					end
					hash.put (data_arr, date)
					if not hash.inserted then
						date.append ("_double")
						hash.put (data_arr, date)
					end
				end
			end
		end

	hash: HASH_TABLE [ARRAY [TUPLE [val: REAL; flag: INTEGER]], STRING]

end
