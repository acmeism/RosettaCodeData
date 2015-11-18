math.randomseed(os.time())
math.random()  -- First number after seeding not random - throw one away

function randList (n)  -- Build table of size n
	local numbers = {}
	for i = 1, n do
		table.insert(numbers, math.random()) -- range correct by default
	end
	return numbers
end

function mean (t)  -- Find mean average of values in table t
	local sum = 0
	for k, v in pairs(t) do
		sum = sum + v
	end
	return sum / #t
end

function stdDev (t)  -- Find population standard deviation of table t
	local squares, avg = 0, mean(t)
	for k, v in pairs(t) do
		squares = squares + ((avg - v) ^ 2)
	end
	local variance = squares / #t
	return math.sqrt(variance)
end

function showHistogram (t)  -- Draw histogram of given table to stdout
	local histBars, compVal = {}
	for range = 0, 9 do
		histBars[range] = 0
		for k, v in pairs(t) do
			compVal = tonumber(string.format("%0.1f", v - 0.05))
			if compVal == range / 10 then
				histBars[range] = histBars[range] + 1
			end
		end
	end
	for k, v in pairs(histBars) do
		io.write("0." .. k .. " " .. string.rep('=', v / #t * 200))
		print(" " .. v)
	end
	print()
end

function showStats (tabSize)  -- Create and display statistics info
	local numList = randList(tabSize)
	print("Table of size " .. #numList)
	print("Mean average: " .. mean(numList))
	print("Standard dev: " .. stdDev(numList))
	showHistogram(numList)
end

for power = 2, 5 do  -- Start of main procedure
	showStats(10 ^ power)
end
