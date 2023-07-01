on isPrime(n)
    if (n < 3) then return (n is 2)
    if (n mod 2 is 0) then return false
    repeat with i from 3 to (n ^ 0.5) div 1 by 2
        if (n mod i is 0) then return false
    end repeat

    return true
end isPrime

-- Test code:
set output to {}
repeat with n from -7 to 100
    if (isPrime(n)) then set end of output to n
end repeat
return output
