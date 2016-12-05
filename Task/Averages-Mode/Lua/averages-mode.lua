function mode(tbl) -- returns table of modes and count
	assert(type(tbl) == 'table')
	local counts = { }
	for _, val in pairs(tbl) do
		-- see http://lua-users.org/wiki/TernaryOperator
		counts[val] = counts[val] and counts[val] + 1 or 1
	end
	local modes = { }
	local modeCount = 0
	for key, val in pairs(counts) do
		if val > modeCount then
			modeCount = val
			modes = {key}
		elseif val == modeCount then
			table.insert(modes, key)
		end
	end
	return modes, modeCount
end

modes, count = mode({1,3,6,6,6,6,7,7,12,12,17})
for _, val in pairs(modes) do io.write(val..' ') end
print("occur(s) ", count, " times")

modes, count = mode({'a', 'a', 'b', 'd', 'd'})
for _, val in pairs(modes) do io.write(val..' ') end
print("occur(s) ", count, " times")
