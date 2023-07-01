n := c:= 0
while (c<100)
    if isTau(++n)
        c++, result .= SubStr("   " n, -3) . (Mod(c, 10) ? " " : "`n")
MsgBox % result
return

isTau(num){
    return (num/(n := StrSplit(Factors(num), ",").Count()) = floor(num/n))
}

Factors(n) {
    Loop, % floor(sqrt(n))
        v := A_Index = 1 ? 1 "," n : mod(n,A_Index) ? v : v "," A_Index "," n//A_Index
    Sort, v, N U D,
    Return, v
}
