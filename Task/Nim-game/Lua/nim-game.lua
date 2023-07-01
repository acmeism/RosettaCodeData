tokens = 12

print("Nim Game\n")
print("Starting with " .. tokens .. " tokens.\n\n")

function printRemaining()
	print(tokens .. " tokens remaining.\n")
end

function playerTurn(take)
	take = math.floor(take)
	if (take < 1 or take > 3) then
		print ("\nTake must be between 1 and 3.\n")
		return false
	end
	
	tokens = tokens - take
	
	print ("\nPlayer takes " .. take .. " tokens.")
	printRemaining()
	return true
end

function computerTurn()
	take = tokens % 4
	tokens = tokens - take
	
	print("Computer takes " .. take .. " tokens.")
	printRemaining()
end

while (tokens > 0) do
	io.write("How many tokens would you like to take?: ")
	if playerTurn(io.read("*n")) then
		computerTurn()
	end
end

print ("Computer wins.")
