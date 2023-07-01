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

-- Task code:
local output, counter, n, sum, astid
set output to {"The first 25 abundant odd numbers:"}
set counter to 0
set n to 1
repeat until (counter = 25)
    set sum to aliquotSum(n)
    if (sum > n) then
        set end of output to "  " & n & "  (proper divisor sum:  " & sum & ")"
        set counter to counter + 1
    end if
    set n to n + 2
end repeat

set end of output to "The one thousandth:"
repeat until (counter = 1000)
    set sum to aliquotSum(n)
    if (sum > n) then set counter to counter + 1
    set n to n + 2
end repeat
set end of output to "  " & (n - 2) & "  (proper divisor sum:  " & sum & ")"

set end of output to "The first > 1,000,000,000:"
set n to 1.000000001E+9
set sum to aliquotSum(n)
repeat until (sum > n)
    set n to n + 2
    set sum to aliquotSum(n)
end repeat
set end of output to "  " & (n div 1000000) & text 2 thru -1 of ((1000000 + ((n mod 1000000) as integer)) as text) & ¬
    "  (proper divisor sum:  " & (sum div 1000000) & text 2 thru -1 of ((1000000 + ((sum mod 1000000) as integer)) as text) & ")"

set astid to AppleScript's text item delimiters
set AppleScript's text item delimiters to linefeed
set output to output as text
set AppleScript's text item delimiters to astid
return output
