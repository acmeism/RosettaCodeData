function emptySet()         return { }  end
function insert(set, item)  set[item] = true  end
function remove(set, item)  set[item] = nil  end
function member(set, item)  return set[item]  end
function size(set)
	local result = 0
	for _ in pairs(set) do result = result + 1 end
	return result
end
function fromTable(tbl) -- ignore the keys of tbl
	local result = { }
	for _, val in pairs(tbl) do
		result[val] = true
	end
	return result
end
function toArray(set)
	local result = { }
	for key in pairs(set) do
		table.insert(result, key)
	end
	return result
end
function printSet(set)
	print(table.concat(toArray(set), ", "))
end
function union(setA, setB)
	local result = { }
	for key, _ in pairs(setA) do
		result[key] = true
	end
	for key, _ in pairs(setB) do
		result[key] = true
	end
	return result
end
function intersection(setA, setB)
	local result = { }
	for key, _ in pairs(setA) do
		if setB[key] then
			result[key] = true
		end
	end
	return result
end
function difference(setA, setB)
	local result = { }
	for key, _ in pairs(setA) do
		if not setB[key] then
			result[key] = true
		end
	end
	return result
end
function subset(setA, setB)
	for key, _ in pairs(setA) do
		if not setB[key] then
			return false
		end
	end
	return true
end
function properSubset(setA, setB)
	return subset(setA, setB) and (size(setA) ~= size(setB))
end
function equals(setA, setB)
	return subset(setA, setB) and (size(setA) == size(setB))
end
