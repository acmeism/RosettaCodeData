class
	APPLICATION

create
	make

feature

	make
		do
			io.put_string ("Survivor is prisoner: " + execute (12, 4).out)
		end

	execute (n, k: INTEGER): INTEGER
			-- Survivor of 'n' prisoners, when every 'k'th is executed.
		require
			n_positive: n > 0
			k_positive: k > 0
			n_larger: n > k
		local
			killidx: INTEGER
			prisoners: LINKED_LIST [INTEGER]
		do
			create prisoners.make
			across
				0 |..| (n - 1) as c
			loop
				prisoners.extend (c.item)
			end
			io.put_string ("Prisoners are executed in the order:%N")
			killidx := 1
			from
			until
				prisoners.count <= 1
			loop
				killidx := killidx + k - 1
				from
				until
					killidx <= prisoners.count
				loop
					killidx := killidx - prisoners.count
				end
				io.put_string (prisoners.at (killidx).out + "%N")
				prisoners.go_i_th (killidx)
				prisoners.remove
			end
			Result := prisoners.at (1)
		ensure
			Result_in_range: Result >= 0 and Result < n
		end

end
