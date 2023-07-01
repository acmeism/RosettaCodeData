(* Uses a Foundation number formatter for brevity. *)
use AppleScript version "2.4" -- OS X 10.10 (Yosemite) or later
use framework "Foundation"

on getNumberFormatter(localeID, numberStyle)
    set formatter to current application's class "NSNumberFormatter"'s new()
    tell formatter to setLocale:(current application's class "NSLocale"'s localeWithLocaleIdentifier:(localeID))
    tell formatter to setNumberStyle:(numberStyle)

    return formatter
end getNumberFormatter

on join(listOfText, delimiter)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delimiter
    set txt to listOfText as text
    set AppleScript's text item delimiters to astid

    return txt
end join

on fourIsMagic(n)
    set n to n as number
    if (n is 4) then return "Four is magic."

    set formatter to getNumberFormatter("en_US", current application's NSNumberFormatterSpellOutStyle)

    set nName to (formatter's stringFromNumber:(n)) as text
    if (nName begins with "minus") then
        set nName to "Negative " & text from word 2 to -1 of nName
    else -- Crude ID-based capitalisation. Good enough for English number names.
        set nName to character id ((id of character 1 of nName) - 32) & text 2 thru -1 of nName
    end if

    set output to {}
    repeat until (n is 4)
        set n to (count nName)
        set lenName to (formatter's stringFromNumber:(n)) as text
        set end of output to nName & " is " & lenName
        set nName to lenName
    end repeat
    set end of output to "four is magic."

    return join(output, ", ")
end fourIsMagic

local tests, output, n
set tests to {-19, 0, 4, 25, 32, 111, 1.234565789E+9}
set output to {}
repeat with n in tests
    set end of output to fourIsMagic(n)
end repeat
return join(output, linefeed)
