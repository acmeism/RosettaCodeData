MsgBox, 262144, , % result := perfect_totient(20)

perfect_totient(n){
    count := sum := tot := 0, str:= "", m := 1
    while (count < n) {
        tot := m, sum := 0
        while (tot != 1) {
            tot := totient(tot)
            sum += tot
        }
        if (sum = m) {
            str .= m ", "
            count++
        }
        m++
    }
    return Trim(str, ", ")
}

totient(n) {
    tot := n,     i := 2
    while (i*i <= n) {
        if !Mod(n, i) {
            while !Mod(n, i)
                n /= i
            tot -= tot / i
        }
        if (i = 2)
            i := 1
        i+=2
    }
    if (n > 1)
        tot -= tot / n
    return tot
}
