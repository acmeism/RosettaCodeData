on isPerfect(n)
    -- All the known perfect numbers listed in Wikipedia end with either 6 or 28.
    -- These endings are either preceded by odd digits or are the numbers themselves.
    tell (n mod 10) to ¬
        if not (((it = 6) and ((n mod 20 = 16) or (n = 6))) or ((it = 8) and ((n mod 200 = 128) or (n = 28)))) then ¬
            return false
    -- Work through the only seven primes p where (2 ^ p - 1) is also prime
    -- and (2 ^ p - 1) * (2 ^ (p - 1)) is a number that AppleScript can handle.
    repeat with p in {2, 3, 5, 7, 13, 17, 19}
        tell (2 ^ p - 1) * (2 ^ (p - 1))
            if (it < n) then
            else
                return (it = n)
            end if
        end tell
    end repeat
    return missing value
end isPerfect

local output, n
set output to {}
repeat with n from 2 to 33551000 by 2
    if (isPerfect(n)) then set end of output to n
end repeat
return output
