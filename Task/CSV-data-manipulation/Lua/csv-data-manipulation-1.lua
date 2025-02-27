-- Lua has no built in methods to handle csv files.
-- it does have string.gmatch, which we use to global.match whatever isn't a comma

print(io.read"l" .. ",SUM")
for line in io.lines() do
	local fields, sum = {}, 0
	for field in line:gmatch"[^,]+" do
		table.insert(fields, field)
		sum = sum + field
	end
	table.insert(fields, sum)
	print(table.concat(fields,","))
end
