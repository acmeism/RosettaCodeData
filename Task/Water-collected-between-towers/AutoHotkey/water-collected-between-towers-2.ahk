data := [[1, 5, 3, 7, 2]
	,[5, 3, 7, 2, 6, 4, 5, 9, 1, 2]
	,[2, 6, 3, 5, 2, 8, 1, 4, 2, 2, 5, 3, 5, 7, 4, 1]
	,[5, 5, 5, 5]
	,[5, 6, 7, 8]
	,[8, 7, 7, 6]
	,[6, 7, 10, 7, 6]]

result := ""
for i, oTwr in data{
	inp := ""
	for i, h in oTwr
		inp .= h ", "
	inp := "[" Trim(inp, ", ") "]"
	x := WCBT(oTwr)
	result .= "Chart " inp " has " x.1 " water units`n" x.2 "------------------------`n"
}
MsgBox % result
