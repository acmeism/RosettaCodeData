c:= 0
loop
{
    if AttractiveNumbers(A_Index)
        c++, result .= SubStr("  " A_Index, -2) . (Mod(c, 20) ? " " : "`n")
    if A_Index = 120
        break
}
MsgBox, 262144, ,% result
return
