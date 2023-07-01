AttractiveNumbers(n){
    c := prime_numbers(n).count()
    if c = 1
        return
    return isPrime(c)
}
isPrime(n){
    return (prime_numbers(n).count() = 1)
}
prime_numbers(n) {
    if (n <= 3)
        return [n]
    ans := []
    done := false
    while !done
    {
        if !Mod(n,2){
            ans.push(2)
            n /= 2
            continue
        }
        if !Mod(n,3) {
            ans.push(3)
            n /= 3
            continue
        }
        if (n = 1)
            return ans

        sr := sqrt(n)
        done := true
        ; try to divide the checked number by all numbers till its square root.
        i := 6
        while (i <= sr+6){
            if !Mod(n, i-1) { ; is n divisible by i-1?
                ans.push(i-1)
                n /= i-1
                done := false
                break
            }
            if !Mod(n, i+1) { ; is n divisible by i+1?
                ans.push(i+1)
                n /= i+1
                done := false
                break
            }
            i += 6
        }
    }
    ans.push(n)
    return ans
}
