test = { "Here", "we", "have", "some", "sample", "strings", "to", "be", "sorted" }

function stringSorter(a, b)
	if string.len(a) == string.len(b) then
		return string.lower(a) < string.lower(b)
	end
	return string.len(a) > string.len(b)
end
table.sort(test, stringSorter)

-- print sorted table
for k,v in pairs(test) do print(v) end
