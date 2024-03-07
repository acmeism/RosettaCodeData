on validateISBN13(ISBN13)
    if (ISBN13's class is not text) then return false

    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to {"-", space}
    set ISBN13 to ISBN13's text items
    set AppleScript's text item delimiters to ""
    set ISBN13 to ISBN13 as text
    set AppleScript's text item delimiters to astid

    if (((count ISBN13) is not 13) or (ISBN13 contains ".") or (ISBN13 contains ",")) then return false
    try
        ISBN13 as number
    on error
        return false
    end try

    set sum to 0
    repeat with i from 1 to 12 by 2
        set sum to sum + (character i of ISBN13) + (character (i + 1) of ISBN13) * 3 -- Automatic text-to-number coercions.
    end repeat

    return ((sum + (character 13 of ISBN13)) mod 10 = 0)
end validateISBN13

-- Test:
set output to {}
set verdicts to {"bad", "good"}
repeat with thisISBN13 in {"978-0596528126", "978-0596528120", "978-1788399081", "978-1788399083"}
    set isValid to validateISBN13(thisISBN13)
    set end of output to thisISBN13 & ": " & item ((isValid as integer) + 1) of verdicts
end repeat

set astid to AppleScript's text item delimiters
set AppleScript's text item delimiters to linefeed
set output to output as text
set AppleScript's text item delimiters to astid
return output
