List := [1,8,2,-3,0,1,1,-2.3,0,5.5,8,6,2,9,11,10,3]
mxDiff := []

loop % List.Count() -1
    mxDiff[d := Abs(list[A_Index+1] - list[A_Index])] .= list[A_Index] ", " list[A_Index+1] " ==> " d "`n"

MsgBox % result := Trim(mxDiff[mxDiff.MaxIndex()], "`n")
