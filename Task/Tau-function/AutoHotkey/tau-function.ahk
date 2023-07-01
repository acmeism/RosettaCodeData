loop 100
    result .= SubStr("   " Tau(A_Index), -3) . (Mod(A_Index, 10) ? " " : "`n")
MsgBox % result
return

Tau(n){
    return StrSplit(Factors(n), ",").Count()
}
Factors(n) {
    Loop, % floor(sqrt(n))
        v := A_Index = 1 ? 1 "," n : mod(n,A_Index) ? v : v "," A_Index "," n//A_Index
    Sort, v, N U D,
    Return, v
}
