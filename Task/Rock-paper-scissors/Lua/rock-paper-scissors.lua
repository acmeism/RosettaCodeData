math.randomseed(os.time())  -- Randomness needed for cpuMove function
math.random()

function cpuMove()
	local totalChance = playerRecord.R + playerRecord.P + playerRecord.S
	if totalChance == 0 then  -- First game, unweighted random
		local choice = math.random(1, 3)
		if choice == 1 then return "R" end
		if choice == 2 then return "P" end
		if choice == 3 then return "S" end
	end
	local choice = math.random(1, totalChance)  -- Weighted random bit
	if choice <= playerRecord.R then return "P" end
	if choice <= playerRecord.R + playerRecord.P then return "S" end
	return "R"
end

function playerMove()  -- Get user input for choice of 'weapon'
	local choice
	repeat
		os.execute("cls")  -- Windows specific command, change per OS
		print("\nRock, Paper, Scissors")
		print("=====================\n")
		print("Scores -\tPlayer:", score.player)
		print("\t\tCPU:", score.cpu .. "\n\t\tDraws:", score.draws)
		io.write("\nChoose [R]ock [P]aper or [S]cissors: ")
		choice = string.upper(string.sub(io.read(), 1, 1))
	until choice == "R" or choice == "P" or choice == "S"
	return choice
end

function checkWinner (c, p)  -- Decide who won, increment scores
	io.write("I chose ")
	if c == "R" then print("rock...") end
	if c == "P" then print("paper...") end
	if c == "S" then print("scissors...") end
	if c == p then
		print("\nDraw!")
		score.draws = score.draws + 1
	elseif	(c == "R" and p == "P") or
			(c == "P" and p == "S") or
			(c == "S" and p == "R") then
				print("\nYou win!")
				score.player = score.player + 1
	else
		print("\nYou lose!")
		score.cpu = score.cpu + 1
	end
end

function updateRecord (move)  -- Keep track of player move history
	if move == "R" then playerRecord.R = playerRecord.R + 1 end
	if move == "P" then playerRecord.P = playerRecord.P + 1 end
	if move == "S" then playerRecord.S = playerRecord.S + 1 end
end

score = {player = 0, cpu = 0, draws = 0}  -- Start of main procedure
playerRecord = {R = 0, P = 0, S = 0}
local playerChoice, cpuChoice
repeat
	cpuChoice = cpuMove()
	playerChoice = playerMove()
	updateRecord(playerChoice)
	checkWinner(cpuChoice, playerChoice)
	io.write("\nPress ENTER to continue or enter 'Q' to quit . . . ")
until string.upper(string.sub(io.read(), 1, 1)) == "Q"
