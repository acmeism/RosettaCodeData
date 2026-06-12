on isPrime(n)
    if (n < 6) then return ((n > 1) and (n is not 4))
    if ((n mod 2 = 0) or (n mod 3 = 0) or (n mod 5 = 0)) then return false
    repeat with i from 7 to (n ^ 0.5) div 1 by 30
        if (n mod i = 0) or (n mod (i + 4) = 0) or (n mod (i + 6) = 0) or (n mod (i + 10) = 0) or ¬
            (n mod (i + 12) = 0) or (n mod (i + 16) = 0) or (n mod (i + 22) = 0) or (n mod (i + 24) = 0) then ¬
            return false
    end repeat

    return true
end isPrime

on neighbourPrimes(max)
    set output to {}

    repeat with p from 3 to max by 2
        if (isPrime(p)) then
            set q to p + 2
            repeat until (isPrime(q))
                set q to q + 2
            end repeat
            if (isPrime(p * q + 2)) then set end of output to p
        end if
    end repeat

    return output
end neighbourPrimes

neighbourPrimes(499)
