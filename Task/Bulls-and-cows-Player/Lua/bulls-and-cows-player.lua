local line = "---------+----------------------------------+-------+-------+"
local digits = {1,2,3,4,5,6,7,8,9}

function and_bits (a, b)
--	print (a, b)
	return a & b -- Lua 5.3
end

function or_bits (a, b)
	return a | b -- Lua 5.3
end


function get_digits (n)
	local tDigits = {}
	for i = 1, #digits do tDigits[i] = digits[i] end
	local ret = {}
	
	math.randomseed(os.time())
	for i = 1, n do
		local d = table.remove (tDigits, math.random(#tDigits))
		table.insert (ret, d)
	end
	return ret
end

function mask (x)
	return 3*x-1 -- any function
end

function score (guess, goal)
	local bits, bulls, cows = 0, 0, 0
	
	for i = 1, #guess do
		if (guess[i] == goal[i]) then
			bulls = bulls + 1
		else
			bits = bits + mask (goal[i])
		end
	end
	for i = 1, #guess do
		if not (guess[i] == goal[i]) then
			local nCow = (and_bits (bits, mask(guess[i])) == 0) and 0 or 1
			cows = cows + nCow
		end
	end
	return bulls, cows
end

function iCopy (list)
	local nList = {}
	for i = 1, #list do nList[i] = list[i] end
	return nList
end

function pick (list, n, got, marker, buf)
--	print ('pick', #list, n)
	local bits = 1
	if got >= n then
		table.insert (list, buf)
	else
		local bits = 1
		for i = 1, #digits do
			if and_bits(marker,bits) == 0 then
				buf[got+1] = i
				pick (list, n, got+1, or_bits (marker, bits), iCopy(buf))
			end
			bits = bits * 2
		end
	end
end

function filter_list (list, guess, bulls, cows)
	local index = 1
	for i = 1, #list do
--		print ('filter_list i: ' .. i)
		local scoreBulls, scoreCows = score (guess, list[i])
		if bulls == scoreBulls and cows == scoreCows then
			list[index] = list[i]
			index = index + 1
		end
	end
	for i = #list, index+1, -1 do
		table.remove (list, i)
	end
end

function game (goal)
	local n = #goal
	local attempt = 1
	local guess = {} -- n-length guess numbers array
	for i = 1, n do table.insert (guess, 0) end -- empty buffer
	local list = {}
	pick (list, n, 0, 0, guess)
	
	local bulls, cows = 0, 0
	while true do
		guess = list[1]
		bulls, cows = score (guess, goal)
		print (' Guess ' .. attempt .. ' |	' ..table.concat(guess), '('..#list..' variants)    ', bulls, cows)
		if bulls == n then return end
		filter_list (list, guess, bulls, cows)
		attempt = attempt + 1
	end
end

local n = 4
local secret = get_digits (n)
print (line..'\nSecret '.. #secret.. ' |      '..table.concat(secret) .. '			    | Bulls | Cows  |' .. '\n' .. line)

game (secret)
