maxNum := 0, str := ""
loop, 1000
{
    Random, rnd, 0, 9
    str .= rnd
    output .= rnd . (Mod(A_Index, 148) ? "" : "`n")
    if A_Index < 5
        continue
    num := SubStr(str, A_Index-4, 5)
    maxNum := maxNum > num ? maxNum : num
    minNum := A_Index = 5 ? num : minNum < num ? minNum : num
}
MsgBox % result := output "`n`nLargest five adjacent digits = " maxNum
                    .  "`n`nSmallest five adjacent digits = " minNum
