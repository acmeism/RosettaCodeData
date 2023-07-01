local lines = {}
for line in (s .. "\n"):gmatch("(.-)\n") do
	local this = {}
	for word in line:gmatch("%S+") do
		table.insert(this, 1, word)
	end
	lines[#lines + 1] = table.concat(this, " ")
end
print(table.concat(lines, "\n"))
