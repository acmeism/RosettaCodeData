on isPrime(n)
    if (n < 4) then return (n > 1)
    if ((n mod 2 is 0) or (n mod 3 is 0)) then return false
    repeat with i from 5 to (n ^ 0.5) div 1 by 6
        if ((n mod i is 0) or (n mod (i + 2) is 0)) then return false
    end repeat

    return true
end isPrime

on task()
    set output to {}
    if (isPrime(1 * 1 + 1)) then set end of output to 1 * 1
    repeat with sqrt from 2 to (1000 ^ 0.5) by 2
        set n to sqrt * sqrt
        if (isPrime(n + 1)) then set end of output to n
    end repeat

    return output
end task

task()
