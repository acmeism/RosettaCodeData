on factors(n)
    set output to {}

    if (n > 0) then
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
    end if

    return output
end factors

on reversedIntVal(n, base)
    set r to n mod base as integer
    set n to n div base
    repeat until (n = 0)
        set r to r * base + n mod base
        set n to n div base
    end repeat

    return r
end reversedIntVal

on hasSpecialDivisors(n, base)
    set divisors to factors(n)
    if (divisors is {}) then return false
    set r to reversedIntVal(n, base)
    repeat with d in divisors
        if (r mod (reversedIntVal(d, base)) > 0) then return false
    end repeat

    return true
end hasSpecialDivisors

local output, base, n
set output to {}
set base to 10
repeat with n from 1 to 199
    if (hasSpecialDivisors(n, base)) then set end of output to n
end repeat
return {|count|:(count output), finds:output}
