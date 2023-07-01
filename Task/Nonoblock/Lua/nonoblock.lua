local examples = {
	{5, {2, 1}},
	{5, {}},
	{10, {8}},
	{15, {2, 3, 2, 3}},
	{5, {2, 3}},
}

function deep (blocks, iBlock, freedom, str)
	if iBlock == #blocks then -- last
		for takenFreedom = 0, freedom do
			print (str..string.rep("0", takenFreedom) .. string.rep("1", blocks[iBlock]) .. string.rep("0", freedom - takenFreedom))
			total = total + 1
		end
	else
		for takenFreedom = 0, freedom do
			local str2 = str..string.rep("0", takenFreedom) .. string.rep("1", blocks[iBlock]) .. "0"
			deep (blocks, iBlock+1, freedom-takenFreedom, str2)
		end
	end
end

function main (cells, blocks) -- number, list
	local str = "	"
	print (cells .. ' cells and {' .. table.concat(blocks, ', ') .. '} blocks')
	local freedom = cells - #blocks + 1 -- freedom
	for iBlock = 1, #blocks do
		freedom = freedom - blocks[iBlock]
	end
	if #blocks == 0 then
		print ('no blocks')
		print (str..string.rep("0", cells))
		total = 1
	elseif freedom < 0 then
		print ('no solutions')
	else
		print ('Possibilities:')
		deep (blocks, 1, freedom, str)
	end
end

for i, example in ipairs (examples) do
	print ("\n--")
	total = 0
	main (example[1], example[2])
	print ('A total of ' .. total .. ' possible configurations.')
end
