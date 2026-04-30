local player_O, blank, player_X = -1, 0, 1
local show_tile = {[player_O]="O", [blank]="-", [player_X]="X"}

function valid_pos_Q(pos)
	return type(pos) == "number" and pos%1 == 0 and 1 <= pos and pos <= 9
end

function member_Q(arr, e)  -- Does `arr` contain `e`?
	for _, val in ipairs(arr) do
		if val == e then return true end
	end
	return false
end

function full_Q(board) return not member_Q(board, blank) end

function sum(arr, idxs)
	local result = 0
	for _,i in ipairs(idxs) do result = result + arr[i] end
	return result
end

-- rcd stands for rows, columns, and diagonals
local rcd = {{1,2,3},{4,5,6},{7,8,9}, {1,4,7},{2,5,8},{3,6,9}, {1,5,9},{3,5,7}}

function won_Q(board)
	for _,idxs in ipairs(rcd) do
		if math.abs(sum(board, idxs)) == 3 then
			return true
		end  -- if
	end  -- for
	return false
end

function you(board)
	local position
	repeat
		io.write("Enter a move(1-" .. 9 .. "): ")
		position = tonumber(io.read("*line"))
	until valid_pos_Q(position) and board[position] == blank
	return position
end

function cpu(board)
	for position, value in ipairs(board) do
		if value == blank then return position end
	end
end

function pos(board)  -- a players takes a turn, returns chosen position
	if board[0] == player_O then
		return cpu(board)
	else
		return you(board)
	end
end

function move(board)
	assert(not full_Q(board))
	local position = pos(board)
	board[position] = board[0]
	board[0] = -board[0]  -- toggle whose turn
	return board
end

function show(board)
	for key, val in ipairs(board) do
		io.write(show_tile[val] .. " ")
		if key % 3 == 0 then io.write"\n" end
	end  -- for
	io.write"\n"
end

-- board[0] indicates whose turn it is
local the_board = { [0]=player_O }
for i = 1, 9 do the_board[i] = blank end

repeat
	move(the_board)
	show(the_board)
until won_Q(the_board) or full_Q(the_board)

if won_Q(the_board) then
	print (show_tile[-the_board[0]], "wins!")
elseif full_Q(the_board) then
	print("tie!")
else
	print("incomplete game")
	assert(false)  -- this should be logically impossible
end  -- if
