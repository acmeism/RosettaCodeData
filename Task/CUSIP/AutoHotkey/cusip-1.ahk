Cusip_Check_Digit(cusip){
    sum := 0, i := 1, x := StrSplit(cusip)
    while (i <= 8) {
        c := x[i]
        if c is digit
            v := c
        else if c is alpha
            v := Asc(c) - 64 + 9
        else if (c = "*")
            v := 36
        else if (c = "@")
            v := 37
        else if (c = "#")
            v := 38
        if (i/2 = Floor(i/2))
            v *= 2
        sum += Floor(v/10) + Mod(v, 10)
        i++
    }
    return (Mod(10 - Mod(sum, 10), 10) = x[9])
}
