-- Generate a list of the ludic numbers up to and including n.
on ludicsTo(n)
    if (n < 1) then return {}
    -- Start with an array of numbers from 2 to n and a ludic collection already containing 1.
    script o
        property array : {}
        property ludics : {1}
    end script
    repeat with i from 2 to n
        set end of o's array to i
    end repeat
    -- Collect ludics and sieve the array until a ludic matches or exceeds the remaining
    -- array length, at which point the array contains just the remaining ludics.
    set thisLudic to 2
    set arrayLength to n - 1
    repeat while (thisLudic < arrayLength)
        set end of o's ludics to thisLudic
        repeat with i from 1 to arrayLength by thisLudic
            set item i of o's array to missing value
        end repeat
        set o's array to o's array's numbers
        set thisLudic to beginning of o's array
        set arrayLength to (count o's array)
    end repeat

    return (o's ludics) & (o's array)
end ludicsTo

on doTask()
    script o
        property ludics : ludicsTo(22000)
    end script

    set output to {}
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to ", "
    set end of output to "First 25 ludic numbers:"
    set end of output to (items 1 thru 25 of o's ludics) as text
    repeat with i from 1 to (count o's ludics)
        if (item i of o's ludics > 1000) then exit repeat
    end repeat
    set end of output to "There are " & (i - 1) & " ludic numbers ≤ 1000."
    set end of output to "2000th-2005th ludic numbers:"
    set end of output to (items 2000 thru 2005 of o's ludics) as text
    set end of output to "Triplets < 250:"
    set triplets to {}
    repeat with x in o's ludics
        set x to x's contents
        if (x > 243) then exit repeat
        if ((x + 2) is in o's ludics) and ((x + 6) is in o's ludics) then
            set end of triplets to "{" & {x, x + 2, x + 6} & "}"
        end if
    end repeat
    set end of output to triplets as text
    set AppleScript's text item delimiters to linefeed
    set output to output as text
    set AppleScript's text item delimiters to astid

    return output
end doTask

return doTask()
