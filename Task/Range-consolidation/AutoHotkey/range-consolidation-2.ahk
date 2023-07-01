test1 := [[1.1, 2.2]]
test2 := [[6.1, 7.2], [7.2, 8.3]]
test3 := [[4, 3], [2, 1]]
test4 := [[4, 3], [2, 1], [-1, -2], [3.9, 10]]
test5 := [[1, 3], [-6, -1], [-4, -5], [8, 2], [-6, -6]]

result := ""
loop, 5
{
	output := ""
	for i, obj in RangeConsolidation(test%A_Index%)
		output .= "[" format("{:g}", obj.1) ", " format("{:g}", obj.2) "], "
	result .= Trim(output, ", ") "`n"
}
MsgBox % result
return
