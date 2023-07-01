on isPrime(n)
    if (n < 4) then return (n > 1)
    if ((n mod 2 is 0) or (n mod 3 is 0)) then return false
    repeat with i from 5 to (n ^ 0.5) div 1 by 6
        if ((n mod i is 0) or (n mod (i + 2) is 0)) then return false
    end repeat

    return true
end isPrime

on isCircularPrime(n)
    if (not isPrime(n)) then return false
    set temp to n
    set c to 0
    repeat while (temp > 9)
        set temp to temp div 10
        set c to c + 1
    end repeat
    set p to (10 ^ c) as integer
    set temp to n
    repeat c times
        set temp to temp mod p * 10 + temp div p
        if ((temp < n) or (not isPrime(temp))) then return false
    end repeat
    return true
end isCircularPrime

-- Return the first c circular primes.
-- Takes 2 as read and checks only odd numbers thereafter.
on circularPrimes(c)
    if (c < 1) then return {}
    set output to {2}
    set n to 3
    set counter to 1
    repeat until (counter = c)
        if (isCircularPrime(n)) then
            set end of output to n
            set counter to counter + 1
        end if
        set n to n + 2
    end repeat
    return output
end circularPrimes

return circularPrimes(19)
