on properDivisors(n)
    set output to {}

    if (n > 1) then
        set sqrt to n ^ 0.5
        set limit to sqrt div 1
        if (limit = sqrt) then
            set end of output to limit
            set limit to limit - 1
        end if
        repeat with i from limit to 2 by -1
            if (n mod i is 0) then
                set beginning of output to i
                set end of output to n div i
            end if
        end repeat
        set beginning of output to 1
    end if

    return output
end properDivisors

(* on isCalmo(n)
    set pds to properDivisors(n)
    set pdCount to (count pds)
    if ((pdCount - 3) mod 3 ≠ 1) then return false
    repeat with i from 2 to (pdCount - 1) by 3
        if (properDivisors((pds's item i) + (pds's item (i + 1)) + (pds's item (i + 2))) ≠ {1}) then ¬
            return false
    end repeat

    return true
end isCalmo *)

-- It turns out that every Calmo number < 5,000,000 is odd
-- and has exactly 6 "eligible" (ie. 7 proper) divisors, so:
on isCalmo(n)
    if (n mod 2 = 0) then return false
    set pds to properDivisors(n)
    return (((count pds) = 7) and ¬
        (properDivisors((pds's item 2) + (pds's item 3) + (pds's item 4)) = {1}) and ¬
        (properDivisors((pds's item 5) + (pds's item 6) + (pds's end)) = {1}))
end isCalmo

on calmoNumbers(limit)
    set output to {}
    repeat with n from 20 to limit
        if (isCalmo(n)) then set end of output to n
    end repeat
    return output
end calmoNumbers

return calmoNumbers(999)
