class
	QUEENS

create
	make

feature {NONE}
	counter: INTEGER

	place_queens(board: ARRAY[INTEGER]; level: INTEGER)
		local
			i, j: INTEGER
			safe: BOOLEAN
		do
			if level > board.count
			then
				counter := counter + 1
			else
				from
					i := 1
				until
					i > board.count
				loop
					safe := True
					from
						j := 1
					until
						j = level or not safe
					loop
						if (board[j] = i)
							or (j - level = i - board[j])
							or (j - level = board[j] - i)
						then
							safe := False
						end
						j := j + 1
					end
					if safe
					then
						board[level] := i
						place_queens(board, level + 1)
					end
					i := i + 1
				end
			end
		end

feature
	possible_positions_of_n_queens(n: INTEGER): INTEGER
		local
			board: ARRAY[INTEGER]
		do
			create board.make_filled (0, 1, n)
			counter := 0
			place_queens(board, 1)
			Result := counter
		end

	make
		local
			n: INTEGER
		do
			io.put_string ("Please enter the number of queens: ")
			io.read_integer
			n := io.last_integer
			print("%NPossible number of placings: " + possible_positions_of_n_queens(n).out + "%N")
		end
end
