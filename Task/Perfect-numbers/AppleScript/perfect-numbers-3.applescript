on aliquotSum(n)
    if (n < 2) then return 0
    set sum to 1
    set sqrt to n ^ 0.5
    set limit to sqrt div 1
    if (limit = sqrt) then
        set sum to sum + limit
        set limit to limit - 1
    end if
    repeat with i from 2 to limit
        if (n mod i is 0) then set sum to sum + i + n div i
    end repeat

    return sum
end aliquotSum

on isPerfect(n)
    if (n > 1.37438691328E+11) then return missing value -- Too high for perfection to be determinable.
    -- All the known perfect numbers listed in Wikipedia end with either 6 or 28.
    -- These endings are either preceded by odd digits or are the numbers themselves.
    tell (n mod 10) to ¬
        return ((((it = 6) and ((n mod 20 = 16) or (n = 6))) or ¬
            ((it = 8) and ((n mod 200 = 128) or (n = 28)))) and ¬
            (my aliquotSum(n) = n))
end isPerfect

local output, n
set output to {}
repeat with n from 1 to 10000
    if (isPerfect(n)) then set end of output to n
end repeat
return output
