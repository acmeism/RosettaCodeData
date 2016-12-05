function showTable(tbl)
	if type(tbl)=='table' then
		local result = {}
		for _, val in pairs(tbl) do
			table.insert(result, showTable(val))
		end
		return '{' .. table.concat(result, ', ') .. '}'
	else
		return (tostring(tbl))
	end
end

function sortTable(op)
	local tbl = op.table or {}
	local column = op.column or 1
	local reverse = op.reverse or false
	local cmp = op.cmp or (function (a, b) return a < b end)
	local compareTables = function (a, b)
		local result = cmp(a[column], b[column])
		if reverse then return not result else return result end
	end
	table.sort(tbl, compareTables)
end

A = {{"quail", "deer", "snake"},
	{"dalmation", "bear", "fox"},
	{"ant", "cougar", "coyote"}}
print('original', showTable(A))

sortTable{table=A}
print('defaults', showTable(A))

sortTable{table=A, column=2}
print('col 2    ', showTable(A))

sortTable{table=A, column=3}
print('col 3    ', showTable(A))

sortTable{table=A, column=3, reverse=true}
print('col 3 rev', showTable(A))

sortTable{table=A, cmp=(function (a, b) return #a < #b end)}
print('by length', showTable(A))
