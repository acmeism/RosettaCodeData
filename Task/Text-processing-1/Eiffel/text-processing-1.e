class
	APPLICATION

create
	make

feature

	make
			-- Summary statistics for 'hash'.
		local
			reject, accept, reading_total: INTEGER
			total, average, file_total: REAL
		do
			read_wordlist
			across
				hash as h
			loop
				io.put_string (h.key + "%T")
				reject := 0
				accept := 0
				total := 0
				across
					h.item as data
				loop
					if data.item.flag > 0 then
						accept := accept + 1
						total := total + data.item.val
					else
						reject := reject + 1
					end
				end
				file_total := file_total + total
				reading_total := reading_total + accept
				io.put_string ("accept: " + accept.out + "%Treject: " + reject.out + "%Ttotal: " + total.out + "%T")
				average := total / accept.to_real
				io.put_string ("average: " + average.out + "%N")
			end
			io.put_string ("File total: " + file_total.out + "%N")
			io.put_string ("Readings total: " + reading_total.out + "%N")
			find_longest_gap
		end

	find_longest_gap
			-- Longest gap (flag values <= 0).
		local
			count: INTEGER
			longest_gap: INTEGER
			end_date: STRING
		do
			create end_date.make_empty
			across
				hash as h
			loop
				across
					h.item as data
				loop
					if data.item.flag <= 0 then
						count := count + 1
					else
						if count > longest_gap then
							longest_gap := count
							end_date := h.key
						end
						count := 0
					end
				end
			end
			io.put_string ("%NThe longest gap is " + longest_gap.out + ". It ends at the date stamp " + end_date + ". %N")
		end

	original_list: STRING = "readings.txt"

	read_wordlist
			-- Preprocessed wordlist in 'hash'.
		local
			l_file: PLAIN_TEXT_FILE
			data: LIST [STRING]
			by_dates: LIST [STRING]
			date: STRING
			data_tup: TUPLE [val: REAL; flag: INTEGER]
			data_arr: ARRAY [TUPLE [val: REAL; flag: INTEGER]]
			i: INTEGER
		do
			create l_file.make_open_read_write (original_list)
			l_file.read_stream (l_file.count)
			data := l_file.last_string.split ('%N')
			l_file.close
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
						date.append ("_double_date_stamp")
						hash.put (data_arr, date)
					end
				end
			end
		end

	hash: HASH_TABLE [ARRAY [TUPLE [val: REAL; flag: INTEGER]], STRING]

end
