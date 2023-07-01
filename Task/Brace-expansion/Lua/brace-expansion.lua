local function wrapEachItem(items, prefix, suffix)
	local itemsWrapped = {}

	for i, item in ipairs(items) do
		itemsWrapped[i] = prefix .. item .. suffix
	end

	return itemsWrapped
end

local function getAllItemCombinationsConcatenated(aItems, bItems)
	local combinations = {}

	for _, a in ipairs(aItems) do
		for _, b in ipairs(bItems) do
			table.insert(combinations, a..b)
		end
	end

	return combinations
end

local getItems -- Forward declaration.

local function getGroup(s, pos, depth)
	local groupItems = {}
	local foundComma = false

	while pos <= #s do
		local items
		items, pos = getItems(s, pos, depth)
		if pos > #s then  break  end

		for _, item in ipairs(items) do
			table.insert(groupItems, item)
		end

		local c = s:sub(pos, pos)

		if c == "}" then -- Possibly end of group.
			if foundComma then  return groupItems, pos+1  end
			return wrapEachItem(groupItems, "{", "}"), pos+1 -- No group.

		elseif c == "," then
			foundComma, pos = true, pos+1
		end
	end

	return nil -- No group.
end

function getItems(s, pos, depth)
	local items = {""}

	while pos <= #s do
		local c = s:sub(pos, pos)

		if depth > 0 and (c == "," or c == "}") then -- End of item in surrounding group.
			return items, pos
		end

		local groupItems, nextPos = nil
		if c == "{" then -- Possibly start of a group.
			groupItems, nextPos = getGroup(s, pos+1, depth+1)
		end

		if groupItems then
			items, pos = getAllItemCombinationsConcatenated(items, groupItems), nextPos
		else
			if c == "\\" and pos < #s then -- Escaped character.
				pos = pos + 1
				c   = c .. s:sub(pos, pos)
			end
			items, pos = wrapEachItem(items, "", c), pos+1
		end
	end

	return items, pos
end

local tests = [[
~/{Downloads,Pictures}/*.{jpg,gif,png}
It{{em,alic}iz,erat}e{d,}, please.
{,{,gotta have{ ,\, again\, }}more }cowbell!
{}} some }{,{\\{ edge, edge} \,}{ cases, {here} \\\\\}
]]

for test in tests:gmatch"[^\n]+" do
	print(test)
	for _, item in ipairs(getItems(test, 1, 0)) do
		print("\t"..item)
	end
	print()
end
