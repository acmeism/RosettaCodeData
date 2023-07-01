result := "n/k|"
loop 20
    result .= SubStr(" " A_Index, -1) " "
l := StrLen(result)
result .= "`n"
loop % l
    result .= "-"
result .= "`n"

loop 21
{
    if !Mod(n := A_Index, 2)
        continue
    result .= SubStr(" " n, -1) " |"
    loop 20
        result .= SubStr(" " jacobi(a := A_Index, n), -1) " "
    result .= "`n"
}
MsgBox, 262144, , % result
return

jacobi(a, n) {
    a := Mod(a, n), t := 1
    while (a != 0) {
        while !Mod(a, 2)
            a := a >> 1, r := Mod(n, 8), t := (r=3 || r=5) ? -t : t
        r := n, n := a, a := r
        if (Mod(a, 4)=3 && Mod(n, 4)=3)
            t := -t
        a := Mod(a, n)
    }
    return (n=1) ? t : 0
}
