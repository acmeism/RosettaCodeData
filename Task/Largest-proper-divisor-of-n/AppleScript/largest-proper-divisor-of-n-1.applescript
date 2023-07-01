on largestProperDivisor(n)
    if (n mod 2 = 0) then return n div 2
    if (n mod 3 = 0) then return n div 3
    if (n < 5) then return missing value
    repeat with i from 5 to (n ^ 0.5 div 1) by 6
        if (n mod i = 0) then return n div i
        if (n mod (i + 2) = 0) then return n div (i + 2)
    end repeat
    return 1
end largestProperDivisor

on task(max)
    script o
        property LPDs : {}
        property output : {}
    end script

    set w to (count (max as text)) * 2 + 3
    set padding to text 1 thru (w - 2) of "          "
    set end of o's LPDs to "1:1" & padding
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to ""
    set c to 1
    repeat with n from 2 to max
        set end of o's LPDs to text 1 thru w of ((n as text) & ":" & largestProperDivisor(n) & padding)
        set c to c + 1
        if (c mod 10 is 0) then
            set end of o's output to o's LPDs as text
            set o's LPDs to {}
        end if
    end repeat
    if (c mod 10 > 0) then set end of o's output to o's LPDs as text
    set AppleScript's text item delimiters to linefeed
    set o's output to o's output as text
    set AppleScript's text item delimiters to astid

    return o's output
end task

task(100)
