math.randomseed(os.time())  -- Random values are used by numList:build()
math.random()

numList = {values = {}}

function numList:contains (n)  -- Check whether list contains n
	for k, v in pairs(self.values) do
		if v == n then return true end
	end
	return false
end

function numList:inOrder ()  -- Check whether list is in order
	for k, v in pairs(self.values) do
		if k ~=v then return false end
	end
	return true
end

function numList:build ()  -- Create necessarily out-of-order list
	local newNum
	repeat
		for i = 1, 9 do
			repeat
				newNum = math.random(1, 9)
			until not numList:contains(newNum)
			table.insert(self.values, newNum)
		end
	until not numList:inOrder()
end

function numList:show ()  -- Display list of numbers on one line
	for k, v in pairs(self.values) do
		io.write(v .. " ")
	end
	io.write(":\t")
end

function numList:reverse (n)  -- Reverse n values from left
	local swapList = {}
	for k, v in pairs(self.values) do
		table.insert(swapList, v)
	end
	for i = 1, n do
		swapList[i] = self.values[n + 1 - i]
	end
	self.values = swapList
end

local score = 0  -- Start of main procedure
print("\nRosetta Code Number Reversal Game in Lua")
print("========================================\n")
numList:build()
repeat
	numList:show()
	numList:reverse(tonumber(io.read()))
	score = score + 1
until numList:inOrder()
numList:show()
print("\nW00t!  You scored:", score)
