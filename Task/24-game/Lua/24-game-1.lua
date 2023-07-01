local function help()
	print [[
 The 24 Game

 Given any four digits in the range 1 to 9, which may have repetitions,
 Using just the +, -, *, and / operators; and the possible use of
 brackets, (), show how to make an answer of 24.

 An answer of "q" will quit the game.
 An answer of "!" will generate a new set of four digits.

 Note: you cannot form multiple digit numbers from the supplied digits,
 so an answer of 12+12 when given 1, 2, 2, and 1 would not be allowed.

 ]]
end

local function generate(n)
	result = {}
	for i=1,n do
		result[i] = math.random(1,9)
	end
	return result
end

local function check(answer, digits)
	local adig = {}
	local ddig = {}
	local index
	local lastWasDigit = false
	for i=1,9 do adig[i] = 0 ddig[i] = 0 end
	allowed = {['(']=true,[')']=true,[' ']=true,['+']=true,['-']=true,['*']=true,['/']=true,['\t']=true,['1']=true,['2']=true,['3']=true,['4']=true,['5']=true,['6']=true,['7']=true,['8']=true,['9']=true}
	for i=1,string.len(answer) do
		if not allowed[string.sub(answer,i,i)] then
			return false
		end
		index = string.byte(answer,i)-48
		if index > 0 and index < 10 then
			if lastWasDigit then
				return false
			end
			lastWasDigit = true
			adig[index] = adig[index] + 1
		else
			lastWasDigit = false
		end
	end
	for i,digit in next,digits do
		ddig[digit] = ddig[digit]+1
	end
	for i=1,9 do
		if adig[i] ~= ddig[i] then
			return false
		end
	end
	return loadstring('return '..answer)()
end

local function game24()
	help()
	math.randomseed(os.time())
	math.random()
	local digits = generate(4)
	local trial = 0
	local answer = 0
	local ans = false
	io.write 'Your four digits:'
	for i,digit in next,digits do
		io.write (' ' .. digit)
	end
	print()
	while ans ~= 24 do
		trial = trial + 1
		io.write("Expression "..trial..": ")
		answer = io.read()
		if string.lower(answer) == 'q' then
			break
		end
		if answer == '!' then
			digits = generate(4)
			io.write ("New digits:")
			for i,digit in next,digits do
				io.write (' ' .. digit)
			end
			print()
		else
			ans = check(answer,digits)
			if ans == false then
				print ('The input '.. answer ..' was wonky!')
			else
				print (' = '.. ans)
				if ans == 24 then
					print ("Thats right!")
				end
			end
		end
	end
end
game24()
