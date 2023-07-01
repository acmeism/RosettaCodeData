test1 := [["A","B"], ["C","D"]]
test2 := [["A","B"], ["B","D"]]
test3 := [["A","B"], ["C","D"], ["D","B"]]
test4 := [["H","I","K"], ["A","B"], ["C","D"], ["D","B"], ["F","G","H"]]

result := "["
loop, 4
{
	for i, obj in SetConsolidation(test%A_Index%)
	{
		output := "["
		for j, v in obj
			output .= """" v ""","
		result .=  RTrim(output, ", ") . "] , "
	}
	result := RTrim(result, ", ") "]`n["
}
MsgBox % RTrim(result, "`n[")
return
