on factorCount(n)
    set counter to 0
    set sqrt to n ^ 0.5
    set limit to sqrt div 1
    if (limit = sqrt) then
        set counter to counter + 1
        set limit to limit - 1
    end if
    repeat with i from limit to 1 by -1
        if (n mod i is 0) then set counter to counter + 2
    end repeat

    return counter
end factorCount

on antiprimes(howMany)
    set output to {}
    set mostFactorsSoFar to 0
    set n to 0
    repeat until ((count output) = howMany)
        set n to n + 1
        tell (factorCount(n))
            if (it > mostFactorsSoFar) then
                set end of output to n
                set mostFactorsSoFar to it
            end if
        end tell
    end repeat

    return output
end antiprimes

antiprimes(20)
