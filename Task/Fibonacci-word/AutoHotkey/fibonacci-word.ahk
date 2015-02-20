SetFormat, FloatFast, 0.15
SetBatchLines, -1
OutPut := "N`tLength`t`tEntropy`n"
        . "1`t" 1 "`t`t" Entropy(FW1 := "1") "`n"
        . "2`t" 1 "`t`t" Entropy(FW2 := "0") "`n"
Loop, 35
{
    FW3 := FW2 FW1, FW1 := FW2, FW2 := FW3
    Output .= A_Index + 2 "`t" StrLen(FW3) (A_Index > 33 ? "" : "`t") "`t" Entropy(FW3) "`n"
}
MsgBox, % Output

Entropy(n)
{
    a := [], len:= StrLen(n), m := n
    while StrLen(m)
    {
        s := SubStr(m, 1, 1)
        m := RegExReplace(m, s, "", c)
        a[s] := c
    }
    for key, val in a
    {
        m := Log(p := val / len)
        e -= p * m / Log(2)
    }
    return, e
}
