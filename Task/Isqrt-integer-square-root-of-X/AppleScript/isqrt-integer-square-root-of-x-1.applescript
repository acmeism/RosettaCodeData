on isqrt(x)
    set q to 1
    repeat until (q > x)
        set q to q * 4
    end repeat
    set z to x
    set r to 0
    repeat while (q > 1)
        set q to q div 4
        set t to z - r - q
        set r to r div 2
        if (t > -1) then
            set z to t
            set r to r + q
        end if
    end repeat

    return r
end isqrt

-- Task code
on intToText(n, separator)
    set output to ""
    repeat until (n < 1000)
        set output to separator & (text 2 thru 4 of ((1000 + (n mod 1000) as integer) as text)) & output
        set n to n div 1000
    end repeat

    return (n as integer as text) & output
end intToText

on doTask()
    -- Get the integer and power results.
    set {integerResults, powerResults} to {{}, {}}
    repeat with x from 0 to 65
        set end of integerResults to isqrt(x)
    end repeat
    repeat with p from 1 to 73 by 2
        set x to 7 ^ p
        if (x > 1.0E+15) then exit repeat -- Beyond the precision of AppleScript reals.
        set end of powerResults to "7^" & p & tab & "(" & intToText(x, ",") & "):" & (tab & tab & intToText(isqrt(x), ","))
    end repeat
    -- Format and output.
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to space
    set output to {"Isqrts of integers from 0 to 65:", space & integerResults, ¬
        "Isqrts of odd powers of 7 from 1 to " & (p - 2) & ":", powerResults}
    set AppleScript's text item delimiters to linefeed
    set output to output as text
    set AppleScript's text item delimiters to astid

    return output
end doTask

doTask()
