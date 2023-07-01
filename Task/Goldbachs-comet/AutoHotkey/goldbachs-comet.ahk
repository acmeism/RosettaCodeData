c := 0
while (c<100)
    if (x := g(A_Index))
        c++, result .= x (Mod(c, 10) ? "`t" : "`n")
MsgBox % result "`ng(1000000) : " g(1000000)
return

g(n, i:=1) {
    if Mod(n, 2)
        return false
    while (++i <= n/2)
        if (is_prime(i) && is_prime(n-i))
            count++
    return count
}

is_prime(N) {
    Loop, % Floor(Sqrt(N))
        if (A_Index > 1 && !Mod(N, A_Index))
            Return false
    Return true
}
