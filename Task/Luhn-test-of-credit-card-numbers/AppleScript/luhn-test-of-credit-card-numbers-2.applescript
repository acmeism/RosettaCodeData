on luhnTest(n)
    -- Accept only text input.
    if (n's class is not text) then return false
    -- Edit out any spaces or dashes.
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to {space, "-"}
    set n to n's text items
    set AppleScript's text item delimiters to ""
    set n to n as text
    set AppleScript's text item delimiters to astid
    -- Check that what's left is numeric.
    try
        n as number
    on error
        return false
    end try

    -- Do the calculation two digits at a time, starting at the end of the text and working back.
    set sum to 0
    repeat with i from ((count n) - 1) to 1 by -2
        set n2 to (text i thru (i + 1) of n) as integer
        tell n2 div 10 mod 10 * 2 to set sum to sum + it div 10 + it mod 10 + n2 mod 10
    end repeat
    -- If there's an odd digit left over, add that in too.
    if (i is 2) then set sum to sum + (character 1 of n)

    return (sum mod 10 is 0)
end luhnTest

-- Test code:
set testResults to {}
repeat with testNumber in {"49927398716", "49927398717", "1234567812345678", "1234567812345670"}
    set end of testResults to {testNumber:testNumber's contents, valid:luhnTest(testNumber)}
end repeat
return testResults
