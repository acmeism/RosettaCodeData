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

-- Task code.
local output, astid, i, maxPDs, maxPDNums, pdCount
set output to {}
set astid to AppleScript's text item delimiters
set AppleScript's text item delimiters to ", "
repeat with i from 1 to 10
    set end of output to (i as text) & "'s proper divisors:  {" & properDivisors(i) & "}"
end repeat
set maxPDs to 0
set maxPDNums to {}
repeat with i from 1 to 20000
    set pdCount to (count properDivisors(i))
    if (pdCount > maxPDs) then
        set maxPDs to pdCount
        set maxPDNums to {i}
    else if (pdCount = maxPDs) then
        set end of maxPDNums to i
    end if
end repeat
set end of output to linefeed & "Largest number of proper divisors for any number from 1 to 20,000:  " & maxPDs
set end of output to "Numbers with this many:  " & maxPDNums
set AppleScript's text item delimiters to linefeed
set output to output as text
set AppleScript's text item delimiters to astid
return output
