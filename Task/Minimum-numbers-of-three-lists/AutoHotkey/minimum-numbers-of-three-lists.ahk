Numbers1 := [5,45,23,21,67]
Numbers2 := [43,22,78,46,38]
Numbers3 := [9,98,12,98,53]
Numbers := []
for i, v in Numbers1
{
    tempArr := []
    loop 3
        tempArr.Push(Numbers%A_Index%[i])
    Numbers.Push(Min(tempArr*))
}

for i, v in Numbers
    result .= v ", "
MsgBox % result := "[" . Trim(result, ", ") . "]"
