function getSuffix (n)
	local lastTwo, lastOne = n % 100, n % 10
	if lastTwo > 3 and lastTwo < 21 then return "th" end
	if lastOne == 1 then return "st" end
	if lastOne == 2 then return "nd" end
	if lastOne == 3 then return "rd" end
	return "th"
end

function Nth (n)
	return n .. "'" .. getSuffix(n)
end

for n = 0, 25 do
	print(Nth(n), Nth(n + 250), Nth(n + 1000))
end
