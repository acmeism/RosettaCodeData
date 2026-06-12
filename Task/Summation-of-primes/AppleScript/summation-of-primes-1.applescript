on isPrime(n)
    if ((n < 4) or (n is 5)) then return (n > 1)
    if ((n mod 2 = 0) or (n mod 3 = 0) or (n mod 5 = 0)) then return false
    repeat with i from 7 to (n ^ 0.5) div 1 by 30
        if ((n mod i = 0) or (n mod (i + 4) = 0) or (n mod (i + 6) = 0) or ¬
            (n mod (i + 10) = 0) or (n mod (i + 12) = 0) or (n mod (i + 16) = 0) or ¬
            (n mod (i + 22) = 0) or (n mod (i + 24) = 0)) then return false
    end repeat

    return true
end isPrime

on sumPrimes below this
    set limit to this - 1
    if (limit < 2) then return 0

    set sum to 2
    repeat with n from 3 to limit by 2
        if (isPrime(n)) then set sum to sum + n
    end repeat

    return sum
end sumPrimes

sumPrimes below 2000000
