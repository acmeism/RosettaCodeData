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
local output, n, counter, astid
set output to {"First 100 tau numbers:"}
set n to 0
set counter to 0
repeat until (counter = 100)
    set n to n + 1
    if (n mod (factorCount(n)) = 0) then
        set counter to counter + 1
        if (counter mod 20 = 1) then set end of output to linefeed
        set end of output to text -5 thru -1 of ("    " & n)
    end if
end repeat
set astid to AppleScript's text item delimiters
set AppleScript's text item delimiters to ""
set output to output as text
set AppleScript's text item delimiters to astid
return output
