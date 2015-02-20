function icsort(numbers)
	table.sort(numbers,function(x,y) return (x..y) > (y..x) end)
	return numbers
end

for _,numbers in pairs({{1, 34, 3, 98, 9, 76, 45, 4}, {54, 546, 548, 60}}) do	
	print(('Numbers: {%s}\n  Largest integer: %s'):format(
		table.concat(numbers,","),table.concat(icsort(numbers))
	))
end
