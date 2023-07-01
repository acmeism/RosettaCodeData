on lookAndSay(startNumber, howMany)
    if (howMany < 1) then return {}

    -- The numbers are handled as lists of digit-value integers for efficiency and output as a list of strings.
    script o
        property previousNumber : {}
        property newNumber : {}
        property output : {}
    end script

    -- "Digitise" the start number.
    repeat
        set beginning of o's newNumber to startNumber mod 10 as integer
        set startNumber to startNumber div 10
        if (startNumber is 0) then exit repeat
    end repeat
    -- Add it to the output as text and successively derive the remaining numbers.
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to ""
    set end of o's output to o's newNumber as text
    repeat (howMany - 1) times
        set o's previousNumber to o's newNumber
        set o's newNumber to {}
        set i to 1
        set previousLength to (o's previousNumber's length)
        set currentDigit to beginning of o's previousNumber
        repeat with j from 2 to previousLength
            set thisDigit to item j of o's previousNumber
            if (thisDigit is not currentDigit) then
                set end of o's newNumber to j - i
                set end of o's newNumber to currentDigit
                set i to j
                set currentDigit to thisDigit
            end if
        end repeat
        set end of o's newNumber to previousLength - i + 1
        set end of o's newNumber to currentDigit

        set end of o's output to o's newNumber as text
    end repeat
    set AppleScript's text item delimiters to astid

    return o's output
end lookAndSay

-- Test code:
return lookAndSay(1, 10)
