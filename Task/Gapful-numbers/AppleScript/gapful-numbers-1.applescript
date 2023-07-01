on isGapful(n)
    set units to n mod 10
    set temp to n div 10
    repeat until (temp < 10)
        set temp to temp div 10
    end repeat

    return (n mod (temp * 10 + units) = 0)
end isGapful

-- Task code:
on getGapfuls(n, q)
    set collector to {}
    repeat until ((count collector) = q)
        if (isGapful(n)) then set end of collector to n
        set n to n + 1
    end repeat
    return collector
end getGapfuls

local output, astid
set output to {}
set astid to AppleScript's text item delimiters
set AppleScript's text item delimiters to "  "
set end of output to "First 30 gapful numbers ≥ 100:" & linefeed & getGapfuls(100, 30)
set end of output to "First 15 gapful numbers ≥ 1,000,000:" & linefeed & getGapfuls(1000000, 15)
set end of output to "First 10 gapful numbers ≥ 100,000,000:" & linefeed & getGapfuls(1.0E+9, 10)
set AppleScript's text item delimiters to linefeed & linefeed
set output to output as text
set AppleScript's text item delimiters to astid
return output
