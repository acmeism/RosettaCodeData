function createNewNumber ()
	math.randomseed(os.time())
	local numbers = {1, 2, 3, 4, 5, 6, 7, 8, 9}
	local tNumb = {} -- list of numbers
	for i = 1, 4 do
		table.insert(tNumb, math.random(#tNumb+1), table.remove(numbers, math.random(#numbers)))
	end
	return tNumb
end

TNumber = createNewNumber ()
print ('(right number: ' .. table.concat (TNumber) .. ')')

function isValueInList (value, list)
	for i, v in ipairs (list) do
		if v == value then return true end
	end
	return false
end

local nGuesses = 0

while not GameOver do
	nGuesses = nGuesses + 1
	print("Enter your guess (or 'q' to quit): ")
	local input
	while not input do
		input = io.read()
	end
	if input == "q" then
		GameOver = true
		return
	end
	local tInput = {}
	for i=1, string.len(input) do
		local number = tonumber(string.sub(input,i,i))
		if number and not isValueInList (number, tInput) then
			table.insert (tInput, number)
		end
	end
	local malformed = false
	if not (string.len(input) == 4) or not (#tInput == 4) then
		print (nGuesses, 'bad input: too short or too long')
		malformed = true
	end
	
	if not malformed then
		print (nGuesses, 'parsed input:', table.concat(tInput, ', '))
		local nBulls, nCows = 0, 0
		for i, number in ipairs (tInput) do
			if TNumber[i] == number then
				nBulls = nBulls + 1
			elseif isValueInList (number, TNumber) then
				nCows = nCows + 1
			end
		end
		print (nGuesses, 'Bulls: '.. nBulls .. ' Cows: ' .. nCows)
		if nBulls == 4 then
			print (nGuesses, 'Win!')
			GameOver = true
		end
	end
end
