on isPrime(n)
    if (n < 2) then return false
    set f to n - 1
    repeat with i from (n - 2) to 2 by -1
        set f to f * i mod n
    end repeat

    return ((f + 1) mod n = 0)
end isPrime

local output, n
set output to {}
repeat with n from 0 to 500
    if (isPrime(n)) then set end of output to n
end repeat
output
