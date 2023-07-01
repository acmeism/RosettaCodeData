on middle3Digits(n)
    try
        n as number -- Errors if n isn't a number or coercible thereto.
        set s to n as text -- Keep for the ouput string.
        if (n mod 1 is not 0) then error (s & " isn't an integer value.")
        if (n < 0) then set n to -n
        if (n < 100) then error (s & " has fewer than three digits.")
        -- Coercing large numbers to text may result in E notation, so extract the digit values individually.
        set theDigits to {}
        repeat until (n = 0)
            set beginning of theDigits to n mod 10 as integer
            set n to n div 10
        end repeat
        set c to (count theDigits)
        if (c mod 2 is 0) then error (s & " has an even number of digits.")
    on error errMsg
        return "middle3Digits handler got an error: " & errMsg
    end try
    set i to (c - 3) div 2 + 1
    set {x, y, z} to items i thru (i + 2) of theDigits

    return "The middle three digits of " & s & " are " & ((x as text) & y & z & ".")
end middle3Digits

-- Test code:
set testNumbers to {123, 12345, 1234567, "987654321", "987654321" as number, 10001, -10001, -123, -100, 100, -12345, 1, 2, -1, -10, 2002, -2002, 0}
set output to {}
repeat with thisNumber in testNumbers
    set end of output to middle3Digits(thisNumber)
end repeat
set astid to AppleScript's text item delimiters
set AppleScript's text item delimiters to linefeed
set output to output as text
set AppleScript's text item delimiters to astid
return output
