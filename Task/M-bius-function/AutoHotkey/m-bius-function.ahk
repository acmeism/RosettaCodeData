loop 100
    result .= SubStr("  " Möbius(A_Index), -1) . (Mod(A_Index, 10) ? "  " : "`n")
MsgBox, 262144, , % result
return

Möbius(n){
    if n=1
        return 1
    x := prime_factors(n)
    c := x.Count()
    sq := []
    for i, v in x
        if sq[v]
            return 0
        else
            sq[v] := 1
    return (c/2 = floor(c/2)) ? 1 : -1
}

prime_factors(n) {
    if (n <= 3)
        return [n]
    ans := [], done := false
    while !done {
        if !Mod(n, 2)
            ans.push(2), n /= 2
        else if !Mod(n, 3)
            ans.push(3), n /= 3
        else if (n = 1)
            return ans
        else {
            sr := sqrt(n), done := true, i := 6
            while (i <= sr+6) {
                if !Mod(n, i-1) { ; is n divisible by i-1?
                    ans.push(i-1), n /= i-1, done := false
                    break
                }
                if !Mod(n, i+1) { ; is n divisible by i+1?
                    ans.push(i+1), n /= i+1, done := false
                    break
                }
                i += 6
    }}}
    ans.push(Format("{:d}", n))
    return ans
}
