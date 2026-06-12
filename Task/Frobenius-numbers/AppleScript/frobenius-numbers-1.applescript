on isPrime(n)
    if (n < 4) then return (n > 1)
    if ((n mod 2 is 0) or (n mod 3 is 0)) then return false
    repeat with i from 5 to (n ^ 0.5) div 1 by 6
        if ((n mod i is 0) or (n mod (i + 2) is 0)) then return false
    end repeat

    return true
end isPrime

on Frobenii(max)
    script o
        property frobs : {}
    end script

    set p to 2
    set n to 3
    repeat
        if (isPrime(n)) then
            set frob to p * n - p - n
            if (frob > max) then exit repeat
            set end of o's frobs to frob
            set p to n
        end if
        set n to n + 2
    end repeat

    return o's frobs
end Frobenii

Frobenii(9999)
