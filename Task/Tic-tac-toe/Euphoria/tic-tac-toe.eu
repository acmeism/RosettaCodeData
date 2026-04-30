include std/console.e
include std/text.e
include std/search.e
include std/sequence.e

sequence board
sequence players = {"X","O"}

function DisplayBoard()
	for i = 1 to 3 do
		for j = 1 to 3 do
			printf(1,"%s",board[i][j])
			if j < 3 then
				printf(1,"%s","|")
			end if
		end for
		if i < 3 then
			puts(1,"\n-----\n")
		else
			puts(1,"\n\n")
		end if
	end for
	
	return 1
end function

function CheckWinner()
sequence temp = board
	for a = 1 to 2 do
		for i = 1 to 3 do
			if equal({"X","X","X"},temp[i]) then
				puts(1,"X wins\n\n")
				return 1
			elsif equal({"O","O","O"},temp[i]) then
				puts(1,"O wins\n\n")
				return 1
			end if
		end for
		temp = columnize(board)
	end for
	if equal({"X","X","X"},{board[1][1],board[2][2],board[3][3]}) or
	   equal({"X","X","X"},{board[1][3],board[2][2],board[3][1]}) then
		puts(1,"X wins\n")
		return 1
	elsif equal({"O","O","O"},{board[1][1],board[2][2],board[3][3]}) or
	   equal({"O","O","O"},{board[1][3],board[2][2],board[3][1]}) then
		puts(1,"O wins\n")
		return 1
	end if	
	
	if moves = 9 then
		puts(1,"Draw\n\n")
		return 1
	end if
	
	return 0
end function

integer turn, row, column, moves
sequence replay
while 1 do
	board = repeat(repeat(" ",3),3)
	DisplayBoard()
	turn = rand(2)
	moves = 0
	
	while 1 do
		while 1 do
			printf(1,"%s's turn\n",players[turn])
			row = prompt_number("Enter row: ",{})
			column = prompt_number("Enter column: ",{})
			if match(board[row][column]," ") then
				board[row][column] = players[turn]
				moves += 1
				exit
			else
				puts(1,"Space already taken - pick again\n")
			end if
		end while
		
		DisplayBoard()
		
		if CheckWinner() then
			exit
		end if
		
		if turn = 1 then
			turn = 2
		else
			turn = 1
		end if
	end while

	replay = lower(prompt_string("Play again (y/n)?\n\n"))
	
	if match(replay,"n") then
		exit
	end if

end while
