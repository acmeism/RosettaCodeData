MsgBox % result := max(prime_numbers(600851475143)*)

prime_numbers(n) {
    if (n <= 3)
        return [n]
    ans := [], done := false
    while !done {
        if !Mod(n,2)
            ans.push(2), n /= 2
        else if !Mod(n,3)
            ans.push(3), n /= 3
        else if (n = 1)
            return ans
        else {
            sr := sqrt(n), done := true, i := 6
            while (i <= sr+6) {
                if !Mod(n, i-1)        ; is n divisible by i-1?
                    ans.push(i-1), n /= i-1, done := false
                if !Mod(n, i+1)        ; is n divisible by i+1?
                    ans.push(i+1), n /= i+1, done := false
                if !done
                    break
                i+=6
    }}}
    ans.push(Format("{:d}", n))
    return ans
}
