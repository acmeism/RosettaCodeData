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
        set ISBN13 to ISBN13 as number
    on error
        return false
    end try

    set sum to 0
    repeat 6 times
        set sum to sum + ISBN13 mod 10 + ISBN13 mod 100 div 10 * 3
        set ISBN13 to ISBN13 div 100
    end repeat

    return ((sum + ISBN13) mod 10 = 0)
end validateISBN13
