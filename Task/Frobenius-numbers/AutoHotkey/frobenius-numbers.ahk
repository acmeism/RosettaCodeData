n := 0, i := 1, pn := 2
loop {
    if isprime(i+=2) {
        if ((f := pn*i - pn - i) > 10000)
            break
        result .= SubStr("   " f, -3) . (Mod(++n, 5) ? "`t" : "`n")
        pn := i
    }
}
MsgBox % result
return

isPrime(n, p=1) {
    if (n < 2)
        return false
    if !Mod(n, 2)
        return (n = 2)
    if !Mod(n, 3)
        return (n = 3)
    while ((p+=4) <= Sqrt(n))
        if !Mod(n, p)
            return false
        else if !Mod(n, p+=2)
            return false
    return true
}
