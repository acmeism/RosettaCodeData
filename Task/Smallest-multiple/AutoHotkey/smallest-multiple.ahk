primes := 1
loop 20
    if prime_numbers(A_Index).Count() = 1
        primes *= A_Index

loop
{
    Result := A_Index*primes
    loop 20
        if Mod(Result, A_Index)
            continue, 2
    break
}
MsgBox % Result
return

prime_numbers(n) { ; http://www.rosettacode.org/wiki/Prime_decomposition#Optimized_Version
    if (n <= 3)
        return [n]
    ans := [], done := false
    while !done
    {
        if !Mod(n,2){
            ans.push(2), n /= 2
            continue
        }
        if !Mod(n,3) {
            ans.push(3), n /= 3
            continue
        }
        if (n = 1)
            return ans
        sr := sqrt(n), done := true
        ; try to divide the checked number by all numbers till its square root.
        i := 6
        while (i <= sr+6){
            if !Mod(n, i-1) { ; is n divisible by i-1?
                ans.push(i-1), n /= i-1, done := false
                break
            }
            if !Mod(n, i+1) { ; is n divisible by i+1?
                ans.push(i+1), n /= i+1, done := false
                break
            }
            i += 6
        }
    }
    ans.push(n)
    return ans
}
