on isPrime(n)
    if (n < 4) then return (n > 1)
    if ((n mod 2 is 0) or (n mod 3 is 0)) then return false
    repeat with i from 5 to (n ^ 0.5) div 1 by 6
        if ((n mod i is 0) or (n mod (i + 2) is 0)) then return false
    end repeat

    return true
end isPrime

on primeFactorCount(n)
    set x to n
    set counter to 0
    if (n > 1) then
        repeat while (n mod 2 = 0)
            set counter to counter + 1
            set n to n div 2
        end repeat
        repeat while (n mod 3 = 0)
            set counter to counter + 1
            set n to n div 3
        end repeat
        set i to 5
        set limit to (n ^ 0.5) div 1
        repeat until (i > limit)
            repeat while (n mod i = 0)
                set counter to counter + 1
                set n to n div i
            end repeat
            tell (i + 2) to repeat while (n mod it = 0)
                set counter to counter + 1
                set n to n div it
            end repeat
            set i to i + 6
            set limit to (n ^ 0.5) div 1
        end repeat
        if (n > 1) then set counter to counter + 1
    end if

    return counter
end primeFactorCount

-- Task code:
local output, n
set output to {}
repeat with n from 1 to 120
    if (isPrime(primeFactorCount(n))) then set end of output to n
end repeat
return output
