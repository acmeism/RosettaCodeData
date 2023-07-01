on factorCount(n)
    if (n < 1) then return 0
    set counter to 2
    set sqrt to n ^ 0.5
    if (sqrt mod 1 = 0) then set counter to 1
    repeat with i from (sqrt div 1) to 2 by -1
        if (n mod i = 0) then set counter to counter + 2
    end repeat

    return counter
end factorCount

-- Task code:
local output, n, astid
set output to {"Positive divisor counts for integers 1 to 100:"}
repeat with n from 1 to 100
    if (n mod 20 = 1) then set end of output to linefeed
    set end of output to text -3 thru -1 of ("  " & factorCount(n))
end repeat
set astid to AppleScript's text item delimiters
set AppleScript's text item delimiters to ""
set output to output as text
set AppleScript's text item delimiters to astid
return output
