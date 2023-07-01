on factors(n)
    set output to {}

    set sqrt to n ^ 0.5
    set limit to sqrt div 1
    if (limit = sqrt) then
        set end of output to limit
        set limit to limit - 1
    end if
    repeat with i from limit to 1 by -1
        if (n mod i is 0) then
            set beginning of output to i
            set end of output to n div i
        end if
    end repeat

    return output
end factors

factors(123456789)
